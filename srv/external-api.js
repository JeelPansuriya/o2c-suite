try {
  require('@sap/xsenv').loadEnv();
} catch (e) {
  // Local fallback only; Cloud Foundry provides environment variables directly.
}

const CUSTOMER_API_URL = process.env.CUSTOMER_API_URL ||
  'http://mtsapserver6g.themdlabs.com:8000/sap/opu/odata/sap/ZCUSTOMER_SRV_O2C_SRV/CustomerSet';

const PRODUCT_API_URL = process.env.PRODUCT_API_URL || '';

module.exports = (srv) => {
  srv.on('READ', 'ApiCustomers', async (req) => {
    const key = getKey(req, 'CustomerId');
    const url = key ? entityUrl(CUSTOMER_API_URL, key) : CUSTOMER_API_URL;
    const data = await readOData(url);
    const rows = Array.isArray(data) ? data : [data];
    return rows.map(mapCustomer);
  });

  srv.on('READ', 'ApiProducts', async (req) => {
    if (!PRODUCT_API_URL) return [];

    const key = getKey(req, 'ProductId');
    const url = key ? entityUrl(PRODUCT_API_URL, key) : PRODUCT_API_URL;
    const data = await readOData(url);
    const rows = Array.isArray(data) ? data : [data];
    return rows.map(mapProduct);
  });

  srv.on('CREATE', 'ApiCustomers', async (req) => {
    const created = await writeOData(CUSTOMER_API_URL, 'POST', mapCustomer(req.data));
    return mapCustomer(created || req.data);
  });

  srv.on('UPDATE', 'ApiCustomers', async (req) => {
    const key = getKey(req, 'CustomerId') || req.data.CustomerId;
    if (!key) req.error(400, 'CustomerId is required for update');

    const payload = mapCustomer(req.data);
    delete payload.CustomerId;

    await writeOData(entityUrl(CUSTOMER_API_URL, key), 'PATCH', payload);
    return { ...req.data, CustomerId: key };
  });

  srv.on('DELETE', 'ApiCustomers', async (req) => {
    const key = getKey(req, 'CustomerId');
    if (!key) req.error(400, 'CustomerId is required for delete');

    await writeOData(entityUrl(CUSTOMER_API_URL, key), 'DELETE');
    return {};
  });

  srv.on('CREATE', 'ApiProducts', async (req) => {
    if (!PRODUCT_API_URL) req.error(501, 'Set PRODUCT_API_URL before creating RAP products');

    const payload = mapProduct(req.data);
    delete payload.ProductId;

    const created = await writeOData(PRODUCT_API_URL, 'POST', payload);
    return mapProduct(created || req.data);
  });

  srv.on('UPDATE', 'ApiProducts', async (req) => {
    if (!PRODUCT_API_URL) req.error(501, 'Set PRODUCT_API_URL before updating RAP products');

    const key = getKey(req, 'ProductId') || req.data.ProductId;
    if (!key) req.error(400, 'ProductId is required for update');

    const payload = mapProduct(req.data);
    delete payload.ProductId;

    await writeOData(entityUrl(PRODUCT_API_URL, key), 'PATCH', payload);
    return { ...req.data, ProductId: key };
  });

  srv.on('DELETE', 'ApiProducts', async (req) => {
    if (!PRODUCT_API_URL) req.error(501, 'Set PRODUCT_API_URL before deleting RAP products');

    const key = getKey(req, 'ProductId');
    if (!key) req.error(400, 'ProductId is required for delete');

    await writeOData(entityUrl(PRODUCT_API_URL, key), 'DELETE');
    return {};
  });
};

async function readOData(url) {
  const response = await fetch(withJsonFormat(url), {
    headers: buildHeaders()
  });

  if (!response.ok) {
    const text = await response.text();
    throw new Error(`External OData call failed (${response.status}): ${text}`);
  }

  const payload = await response.json();
  return unwrapOData(payload);
}

function unwrapOData(payload) {
  if (payload && payload.d && Array.isArray(payload.d.results)) return payload.d.results;
  if (payload && payload.d) return payload.d;
  if (payload && Array.isArray(payload.value)) return payload.value;
  return payload;
}

function withJsonFormat(url) {
  return url.includes('$format=') ? url : `${url}${url.includes('?') ? '&' : '?'}$format=json`;
}

function entityUrl(collectionUrl, key) {
  const cleanUrl = collectionUrl.replace(/\/$/, '');
  return `${cleanUrl}('${encodeURIComponent(key)}')`;
}

function buildHeaders() {
  const headers = {
    accept: 'application/json'
  };

  const user = process.env.EXTERNAL_API_USER || process.env.CUSTOMER_API_USER;
  const password = process.env.EXTERNAL_API_PASSWORD || process.env.CUSTOMER_API_PASSWORD;

  if (user && password) {
    const token = Buffer
      .from(`${user}:${password}`)
      .toString('base64');
    headers.authorization = `Basic ${token}`;
  }

  return headers;
}

async function writeOData(url, method, payload) {
  const csrf = await fetchCsrfToken(url);
  const response = await fetch(url, {
    method,
    headers: {
      ...buildHeaders(),
      'content-type': 'application/json',
      'x-csrf-token': csrf.token,
      cookie: csrf.cookie
    },
    body: payload && method !== 'DELETE' ? JSON.stringify(payload) : undefined
  });

  if (!response.ok) {
    const text = await response.text();
    throw new Error(`External OData write failed (${response.status}): ${text}`);
  }

  if (response.status === 204) return {};

  const text = await response.text();
  return text ? unwrapOData(JSON.parse(text)) : {};
}

async function fetchCsrfToken(url) {
  const response = await fetch(serviceRoot(url), {
    headers: {
      ...buildHeaders(),
      'x-csrf-token': 'Fetch'
    }
  });

  if (!response.ok) {
    const text = await response.text();
    throw new Error(`CSRF token fetch failed (${response.status}): ${text}`);
  }

  const token = response.headers.get('x-csrf-token') || '';
  if (!token) {
    throw new Error('CSRF token fetch did not return x-csrf-token');
  }

  return {
    token,
    cookie: collectCookies(response.headers)
  };
}

function collectCookies(headers) {
  if (typeof headers.getSetCookie === 'function') {
    return headers.getSetCookie().map((cookie) => cookie.split(';')[0]).join('; ');
  }

  const cookie = headers.get('set-cookie') || '';
  return cookie
    .split(/,(?=[^;,]+=)/)
    .map((part) => part.split(';')[0].trim())
    .filter(Boolean)
    .join('; ');
}

function serviceRoot(url) {
  const cleanUrl = url.split('?')[0];
  const marker = '/sap/opu/odata/sap/';
  const index = cleanUrl.indexOf(marker);

  if (index >= 0) {
    const parts = cleanUrl.slice(index + marker.length).split('/');
    return cleanUrl.slice(0, index + marker.length) + parts[0] + '/';
  }

  const collectionIndex = cleanUrl.lastIndexOf('/');
  return cleanUrl.slice(0, collectionIndex + 1);
}

function getKey(req, keyName) {
  const param = req.params && req.params[0];
  if (param && param[keyName]) return param[keyName];

  const where = req.query && req.query.SELECT && req.query.SELECT.where;
  if (!where) return '';

  const index = where.findIndex((part) => part && part.ref && part.ref[0] === keyName);
  if (index >= 0 && where[index + 2] && where[index + 2].val) return where[index + 2].val;

  return '';
}

function mapCustomer(row) {
  return {
    CustomerId: row.CustomerId,
    CustomerName: row.CustomerName,
    Email: row.Email,
    Phone: row.Phone,
    Address: row.Address,
    CreditLimit: row.CreditLimit,
    UsedCredit: row.UsedCredit,
    Status: row.Status
  };
}

function mapProduct(row) {
  return {
    ProductId: row.ProductId || row.prod_id || row.product_id,
    ProductName: row.ProductName || row.prod_name || row.product_name,
    Category: row.Category || row.category,
    Price: row.Price || row.price,
    Currency: row.Currency || row.currency,
    Stock: row.Stock || row.stock,
    Status: row.Status || row.status
  };
}
