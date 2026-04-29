module.exports = (srv) => {

  // ─── ORDERS: credit check before create ──────────────────────────────────
  srv.before('CREATE', 'Orders', async (req) => {
    const { customerID, totalAmount } = req.data;

    if (!customerID)                       req.error(400, 'Customer is mandatory');
    if (!totalAmount || totalAmount <= 0)  req.error(400, 'Total amount must be greater than 0');

    const customer = await SELECT.one.from('o2c.Customers').where({ customerID });

    if (!customer) {
      req.error(400, `Customer '${customerID}' does not exist`);
    }

    if ((customer.usedCredit || 0) + totalAmount > customer.creditLimit) {
      req.error(400, `Credit limit exceeded (limit: ${customer.creditLimit}, used: ${customer.usedCredit}, requested: ${totalAmount})`);
    }
  });

  // ─── ORDER ITEMS: validate order + product exist, check stock ────────────
  srv.before('CREATE', 'OrderItems', async (req) => {
    const { orderID, productID, quantity, unitPrice } = req.data;

    if (!orderID)   req.error(400, 'Order is mandatory');
    if (!productID) req.error(400, 'Product is mandatory');

    const order = await SELECT.one.from('o2c.Orders').where({ orderID });
    if (!order) req.error(400, `Order '${orderID}' does not exist`);

    const product = await SELECT.one.from('o2c.Products').where({ productID });
    if (!product) req.error(400, `Product '${productID}' does not exist`);

    const qty = quantity || 1;
    if (product.stock < qty) {
      req.error(400, `Insufficient stock for '${product.productName}' (available: ${product.stock}, requested: ${qty})`);
    }

    // Auto-fill unit price from product if not supplied
    if (!req.data.unitPrice) req.data.unitPrice = product.price;
    if (!req.data.itemTotal)  req.data.itemTotal  = (req.data.unitPrice || product.price) * qty;
  });

  // ─── APPROVALS: validate order exists ────────────────────────────────────
  srv.before('CREATE', 'Approvals', async (req) => {
    const { orderID } = req.data;
    if (!orderID) req.error(400, 'Order is mandatory');

    const order = await SELECT.one.from('o2c.Orders').where({ orderID });
    if (!order) req.error(400, `Order '${orderID}' does not exist`);
  });

  // ─── INVOICES: validate order exists ─────────────────────────────────────
  srv.before('CREATE', 'Invoices', async (req) => {
    const { orderID } = req.data;
    if (!orderID) req.error(400, 'Order is mandatory');

    const order = await SELECT.one.from('o2c.Orders').where({ orderID });
    if (!order) req.error(400, `Order '${orderID}' does not exist`);
  });

  // ─── PAYMENTS: validate invoice exists ───────────────────────────────────
  srv.before('CREATE', 'Payments', async (req) => {
    const { invoiceID, amountPaid } = req.data;
    if (!invoiceID) req.error(400, 'Invoice is mandatory');

    const invoice = await SELECT.one.from('o2c.Invoices').where({ invoiceID });
    if (!invoice) req.error(400, `Invoice '${invoiceID}' does not exist`);

    if (!amountPaid || amountPaid <= 0) {
      req.error(400, 'Amount paid must be greater than 0');
    }
  });

};