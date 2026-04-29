using O2CService as service from './o2c-service';
using from '@sap/cds/common';

// ─── VALUE HELP: ENUM FIELDS (inline dropdowns) ────────────────────────────

annotate service.Customers with {
  status @Common.ValueListWithFixedValues : true;
}

annotate service.Products with {
  status @Common.ValueListWithFixedValues : true;
}

annotate service.Orders with {
  creditStatus @Common.ValueListWithFixedValues : true;
  orderStatus  @Common.ValueListWithFixedValues : true;

  // Dropdown from Customers list
  customerID @(
    Common.Text                     : customer.customerName,
    Common.TextArrangement          : #TextFirst,
    Common.ValueListWithFixedValues : false,
    Common.ValueList : {
      CollectionPath : 'Customers',
      Parameters     : [
        {
          $Type             : 'Common.ValueListParameterOut',
          LocalDataProperty : customerID,
          ValueListProperty : 'customerID'
        },
        {
          $Type             : 'Common.ValueListParameterDisplayOnly',
          ValueListProperty : 'customerName'
        },
        {
          $Type             : 'Common.ValueListParameterDisplayOnly',
          ValueListProperty : 'email'
        },
        {
          $Type             : 'Common.ValueListParameterDisplayOnly',
          ValueListProperty : 'creditLimit'
        },
        {
          $Type             : 'Common.ValueListParameterDisplayOnly',
          ValueListProperty : 'status'
        }
      ]
    }
  );
}

annotate service.OrderItems with {
  // Dropdown from Orders list
  orderID @(
    Common.Text                     : order.orderID,
    Common.ValueListWithFixedValues : false,
    Common.ValueList : {
      CollectionPath : 'Orders',
      Parameters     : [
        {
          $Type             : 'Common.ValueListParameterOut',
          LocalDataProperty : orderID,
          ValueListProperty : 'orderID'
        },
        {
          $Type             : 'Common.ValueListParameterDisplayOnly',
          ValueListProperty : 'customerID'
        },
        {
          $Type             : 'Common.ValueListParameterDisplayOnly',
          ValueListProperty : 'orderDate'
        },
        {
          $Type             : 'Common.ValueListParameterDisplayOnly',
          ValueListProperty : 'orderStatus'
        }
      ]
    }
  );

  // Dropdown from Products list
  productID @(
    Common.Text                     : product.productName,
    Common.TextArrangement          : #TextFirst,
    Common.ValueListWithFixedValues : false,
    Common.ValueList : {
      CollectionPath : 'Products',
      Parameters     : [
        {
          $Type             : 'Common.ValueListParameterOut',
          LocalDataProperty : productID,
          ValueListProperty : 'productID'
        },
        {
          $Type             : 'Common.ValueListParameterDisplayOnly',
          ValueListProperty : 'productName'
        },
        {
          $Type             : 'Common.ValueListParameterDisplayOnly',
          ValueListProperty : 'category'
        },
        {
          $Type             : 'Common.ValueListParameterDisplayOnly',
          ValueListProperty : 'price'
        },
        {
          $Type             : 'Common.ValueListParameterDisplayOnly',
          ValueListProperty : 'stock'
        }
      ]
    }
  );
}

annotate service.Approvals with {
  decision @Common.ValueListWithFixedValues : true;

  // Dropdown from Orders list
  orderID @(
    Common.ValueListWithFixedValues : false,
    Common.ValueList : {
      CollectionPath : 'Orders',
      Parameters     : [
        {
          $Type             : 'Common.ValueListParameterOut',
          LocalDataProperty : orderID,
          ValueListProperty : 'orderID'
        },
        {
          $Type             : 'Common.ValueListParameterDisplayOnly',
          ValueListProperty : 'customerID'
        },
        {
          $Type             : 'Common.ValueListParameterDisplayOnly',
          ValueListProperty : 'totalAmount'
        },
        {
          $Type             : 'Common.ValueListParameterDisplayOnly',
          ValueListProperty : 'creditStatus'
        },
        {
          $Type             : 'Common.ValueListParameterDisplayOnly',
          ValueListProperty : 'orderStatus'
        }
      ]
    }
  );
}

annotate service.Invoices with {
  invoiceStatus @Common.ValueListWithFixedValues : true;

  // Dropdown from Orders list
  orderID @(
    Common.ValueListWithFixedValues : false,
    Common.ValueList : {
      CollectionPath : 'Orders',
      Parameters     : [
        {
          $Type             : 'Common.ValueListParameterOut',
          LocalDataProperty : orderID,
          ValueListProperty : 'orderID'
        },
        {
          $Type             : 'Common.ValueListParameterDisplayOnly',
          ValueListProperty : 'customerID'
        },
        {
          $Type             : 'Common.ValueListParameterDisplayOnly',
          ValueListProperty : 'totalAmount'
        },
        {
          $Type             : 'Common.ValueListParameterDisplayOnly',
          ValueListProperty : 'orderStatus'
        }
      ]
    }
  );
}

annotate service.Payments with {
  paymentMode   @Common.ValueListWithFixedValues : true;
  paymentStatus @Common.ValueListWithFixedValues : true;

  // Dropdown from Invoices list
  invoiceID @(
    Common.ValueListWithFixedValues : false,
    Common.ValueList : {
      CollectionPath : 'Invoices',
      Parameters     : [
        {
          $Type             : 'Common.ValueListParameterOut',
          LocalDataProperty : invoiceID,
          ValueListProperty : 'invoiceID'
        },
        {
          $Type             : 'Common.ValueListParameterDisplayOnly',
          ValueListProperty : 'orderID'
        },
        {
          $Type             : 'Common.ValueListParameterDisplayOnly',
          ValueListProperty : 'invoiceDate'
        },
        {
          $Type             : 'Common.ValueListParameterDisplayOnly',
          ValueListProperty : 'amount'
        },
        {
          $Type             : 'Common.ValueListParameterDisplayOnly',
          ValueListProperty : 'invoiceStatus'
        }
      ]
    }
  );
}

// ─── UI ANNOTATIONS ────────────────────────────────────────────────────────

annotate service.Customers with @(
  UI.HeaderInfo : {
    TypeName       : 'Customer',
    TypeNamePlural : 'Customers',
    Title          : { $Type : 'UI.DataField', Value : customerName },
    Description    : { $Type : 'UI.DataField', Value : customerID }
  },
  UI.SelectionFields : [ customerID, customerName, email, status ],
  UI.LineItem : [
    { $Type : 'UI.DataField', Value : customerID,   Label : 'Customer ID' },
    { $Type : 'UI.DataField', Value : customerName, Label : 'Customer Name' },
    { $Type : 'UI.DataField', Value : email,        Label : 'Email' },
    { $Type : 'UI.DataField', Value : phone,        Label : 'Phone' },
    { $Type : 'UI.DataField', Value : creditLimit,  Label : 'Credit Limit' },
    { $Type : 'UI.DataField', Value : usedCredit,   Label : 'Used Credit' },
    { $Type : 'UI.DataField', Value : status,       Label : 'Status' }
  ],
  UI.FieldGroup #General : {
    Data : [
      { $Type : 'UI.DataField', Value : customerID,   Label : 'Customer ID' },
      { $Type : 'UI.DataField', Value : customerName, Label : 'Customer Name' },
      { $Type : 'UI.DataField', Value : email,        Label : 'Email' },
      { $Type : 'UI.DataField', Value : phone,        Label : 'Phone' },
      { $Type : 'UI.DataField', Value : address,      Label : 'Address' },
      { $Type : 'UI.DataField', Value : creditLimit,  Label : 'Credit Limit' },
      { $Type : 'UI.DataField', Value : usedCredit,   Label : 'Used Credit' },
      { $Type : 'UI.DataField', Value : status,       Label : 'Status' }
    ]
  },
  UI.Facets : [
    {
      $Type  : 'UI.ReferenceFacet',
      ID     : 'CustomerGeneral',
      Label  : 'General Information',
      Target : '@UI.FieldGroup#General'
    }
  ],
  Capabilities.InsertRestrictions : { Insertable : true },
  Capabilities.UpdateRestrictions : { Updatable  : true },
  Capabilities.DeleteRestrictions : { Deletable  : true }
);

annotate service.Products with @(
  UI.HeaderInfo : {
    TypeName       : 'Product',
    TypeNamePlural : 'Products',
    Title          : { $Type : 'UI.DataField', Value : productName },
    Description    : { $Type : 'UI.DataField', Value : productID }
  },
  UI.SelectionFields : [ productID, productName, category, status ],
  UI.LineItem : [
    { $Type : 'UI.DataField', Value : productID,   Label : 'Product ID' },
    { $Type : 'UI.DataField', Value : productName, Label : 'Product Name' },
    { $Type : 'UI.DataField', Value : category,    Label : 'Category' },
    { $Type : 'UI.DataField', Value : price,       Label : 'Price' },
    { $Type : 'UI.DataField', Value : stock,       Label : 'Stock' },
    { $Type : 'UI.DataField', Value : status,      Label : 'Status' }
  ],
  UI.FieldGroup #General : {
    Data : [
      { $Type : 'UI.DataField', Value : productID,   Label : 'Product ID' },
      { $Type : 'UI.DataField', Value : productName, Label : 'Product Name' },
      { $Type : 'UI.DataField', Value : category,    Label : 'Category' },
      { $Type : 'UI.DataField', Value : price,       Label : 'Price' },
      { $Type : 'UI.DataField', Value : stock,       Label : 'Stock' },
      { $Type : 'UI.DataField', Value : status,      Label : 'Status' }
    ]
  },
  UI.Facets : [
    {
      $Type  : 'UI.ReferenceFacet',
      ID     : 'ProductGeneral',
      Label  : 'General Information',
      Target : '@UI.FieldGroup#General'
    }
  ],
  Capabilities.InsertRestrictions : { Insertable : true },
  Capabilities.UpdateRestrictions : { Updatable  : true },
  Capabilities.DeleteRestrictions : { Deletable  : true }
);

annotate service.Orders with @(
  UI.HeaderInfo : {
    TypeName       : 'Sales Order',
    TypeNamePlural : 'Sales Orders',
    Title          : { $Type : 'UI.DataField', Value : orderID },
    Description    : { $Type : 'UI.DataField', Value : customerID }
  },
  UI.SelectionFields : [ orderID, customerID, creditStatus, orderStatus ],
  UI.LineItem : [
    { $Type : 'UI.DataField', Value : orderID,      Label : 'Order ID' },
    { $Type : 'UI.DataField', Value : customerID,   Label : 'Customer ID' },
    { $Type : 'UI.DataField', Value : orderDate,    Label : 'Order Date' },
    { $Type : 'UI.DataField', Value : totalAmount,  Label : 'Total Amount' },
    { $Type : 'UI.DataField', Value : creditStatus, Label : 'Credit Status' },
    { $Type : 'UI.DataField', Value : orderStatus,  Label : 'Order Status' }
  ],
  UI.FieldGroup #General : {
    Data : [
      { $Type : 'UI.DataField', Value : orderID,      Label : 'Order ID' },
      { $Type : 'UI.DataField', Value : customerID,   Label : 'Customer' },
      { $Type : 'UI.DataField', Value : orderDate,    Label : 'Order Date' },
      { $Type : 'UI.DataField', Value : totalAmount,  Label : 'Total Amount' },
      { $Type : 'UI.DataField', Value : creditStatus, Label : 'Credit Status' },
      { $Type : 'UI.DataField', Value : orderStatus,  Label : 'Order Status' }
    ]
  },
  UI.Facets : [
    {
      $Type  : 'UI.ReferenceFacet',
      ID     : 'OrderGeneral',
      Label  : 'General Information',
      Target : '@UI.FieldGroup#General'
    }
  ],
  Capabilities.InsertRestrictions : { Insertable : true },
  Capabilities.UpdateRestrictions : { Updatable  : true },
  Capabilities.DeleteRestrictions : { Deletable  : true }
);

annotate service.OrderItems with @(
  UI.HeaderInfo : {
    TypeName       : 'Order Item',
    TypeNamePlural : 'Order Items',
    Title          : { $Type : 'UI.DataField', Value : itemID },
    Description    : { $Type : 'UI.DataField', Value : orderID }
  },
  UI.SelectionFields : [ itemID, orderID, productID ],
  UI.LineItem : [
    { $Type : 'UI.DataField', Value : itemID,     Label : 'Item ID' },
    { $Type : 'UI.DataField', Value : orderID,    Label : 'Order ID' },
    { $Type : 'UI.DataField', Value : productID,  Label : 'Product' },
    { $Type : 'UI.DataField', Value : quantity,   Label : 'Quantity' },
    { $Type : 'UI.DataField', Value : unitPrice,  Label : 'Unit Price' },
    { $Type : 'UI.DataField', Value : itemTotal,  Label : 'Item Total' }
  ],
  UI.FieldGroup #General : {
    Data : [
      { $Type : 'UI.DataField', Value : itemID,    Label : 'Item ID' },
      { $Type : 'UI.DataField', Value : orderID,   Label : 'Order' },
      { $Type : 'UI.DataField', Value : productID, Label : 'Product' },
      { $Type : 'UI.DataField', Value : quantity,  Label : 'Quantity' },
      { $Type : 'UI.DataField', Value : unitPrice, Label : 'Unit Price' },
      { $Type : 'UI.DataField', Value : itemTotal, Label : 'Item Total' }
    ]
  },
  UI.Facets : [
    {
      $Type  : 'UI.ReferenceFacet',
      ID     : 'OrderItemGeneral',
      Label  : 'General Information',
      Target : '@UI.FieldGroup#General'
    }
  ],
  Capabilities.InsertRestrictions : { Insertable : true },
  Capabilities.UpdateRestrictions : { Updatable  : true },
  Capabilities.DeleteRestrictions : { Deletable  : true }
);

annotate service.Approvals with @(
  UI.HeaderInfo : {
    TypeName       : 'Credit Approval',
    TypeNamePlural : 'Credit Approvals',
    Title          : { $Type : 'UI.DataField', Value : approvalID },
    Description    : { $Type : 'UI.DataField', Value : orderID }
  },
  UI.SelectionFields : [ approvalID, orderID, decision, approvedBy ],
  UI.LineItem : [
    { $Type : 'UI.DataField', Value : approvalID, Label : 'Approval ID' },
    { $Type : 'UI.DataField', Value : orderID,    Label : 'Order' },
    { $Type : 'UI.DataField', Value : decision,   Label : 'Decision' },
    { $Type : 'UI.DataField', Value : remarks,    Label : 'Remarks' },
    { $Type : 'UI.DataField', Value : approvedBy, Label : 'Approved By' },
    { $Type : 'UI.DataField', Value : approvedOn, Label : 'Approved On' }
  ],
  UI.FieldGroup #General : {
    Data : [
      { $Type : 'UI.DataField', Value : approvalID, Label : 'Approval ID' },
      { $Type : 'UI.DataField', Value : orderID,    Label : 'Order' },
      { $Type : 'UI.DataField', Value : decision,   Label : 'Decision' },
      { $Type : 'UI.DataField', Value : remarks,    Label : 'Remarks' },
      { $Type : 'UI.DataField', Value : approvedBy, Label : 'Approved By' },
      { $Type : 'UI.DataField', Value : approvedOn, Label : 'Approved On' }
    ]
  },
  UI.Facets : [
    {
      $Type  : 'UI.ReferenceFacet',
      ID     : 'ApprovalGeneral',
      Label  : 'Approval Information',
      Target : '@UI.FieldGroup#General'
    }
  ],
  Capabilities.InsertRestrictions : { Insertable : true },
  Capabilities.UpdateRestrictions : { Updatable  : true },
  Capabilities.DeleteRestrictions : { Deletable  : true }
);

annotate service.Invoices with @(
  UI.HeaderInfo : {
    TypeName       : 'Invoice',
    TypeNamePlural : 'Invoices',
    Title          : { $Type : 'UI.DataField', Value : invoiceID },
    Description    : { $Type : 'UI.DataField', Value : orderID }
  },
  UI.SelectionFields : [ invoiceID, orderID, invoiceStatus ],
  UI.LineItem : [
    { $Type : 'UI.DataField', Value : invoiceID,     Label : 'Invoice ID' },
    { $Type : 'UI.DataField', Value : orderID,       Label : 'Order' },
    { $Type : 'UI.DataField', Value : invoiceDate,   Label : 'Invoice Date' },
    { $Type : 'UI.DataField', Value : amount,        Label : 'Amount' },
    { $Type : 'UI.DataField', Value : dueDate,       Label : 'Due Date' },
    { $Type : 'UI.DataField', Value : invoiceStatus, Label : 'Invoice Status' }
  ],
  UI.FieldGroup #General : {
    Data : [
      { $Type : 'UI.DataField', Value : invoiceID,     Label : 'Invoice ID' },
      { $Type : 'UI.DataField', Value : orderID,       Label : 'Order' },
      { $Type : 'UI.DataField', Value : invoiceDate,   Label : 'Invoice Date' },
      { $Type : 'UI.DataField', Value : amount,        Label : 'Amount' },
      { $Type : 'UI.DataField', Value : dueDate,       Label : 'Due Date' },
      { $Type : 'UI.DataField', Value : invoiceStatus, Label : 'Invoice Status' }
    ]
  },
  UI.Facets : [
    {
      $Type  : 'UI.ReferenceFacet',
      ID     : 'InvoiceGeneral',
      Label  : 'Invoice Information',
      Target : '@UI.FieldGroup#General'
    }
  ],
  Capabilities.InsertRestrictions : { Insertable : true },
  Capabilities.UpdateRestrictions : { Updatable  : true },
  Capabilities.DeleteRestrictions : { Deletable  : true }
);

annotate service.Payments with @(
  UI.HeaderInfo : {
    TypeName       : 'Payment',
    TypeNamePlural : 'Payments',
    Title          : { $Type : 'UI.DataField', Value : paymentID },
    Description    : { $Type : 'UI.DataField', Value : invoiceID }
  },
  UI.SelectionFields : [ paymentID, invoiceID, paymentMode, paymentStatus ],
  UI.LineItem : [
    { $Type : 'UI.DataField', Value : paymentID,     Label : 'Payment ID' },
    { $Type : 'UI.DataField', Value : invoiceID,     Label : 'Invoice' },
    { $Type : 'UI.DataField', Value : amountPaid,    Label : 'Amount Paid' },
    { $Type : 'UI.DataField', Value : paymentDate,   Label : 'Payment Date' },
    { $Type : 'UI.DataField', Value : paymentMode,   Label : 'Payment Mode' },
    { $Type : 'UI.DataField', Value : paymentStatus, Label : 'Payment Status' }
  ],
  UI.FieldGroup #General : {
    Data : [
      { $Type : 'UI.DataField', Value : paymentID,     Label : 'Payment ID' },
      { $Type : 'UI.DataField', Value : invoiceID,     Label : 'Invoice' },
      { $Type : 'UI.DataField', Value : amountPaid,    Label : 'Amount Paid' },
      { $Type : 'UI.DataField', Value : paymentDate,   Label : 'Payment Date' },
      { $Type : 'UI.DataField', Value : paymentMode,   Label : 'Payment Mode' },
      { $Type : 'UI.DataField', Value : paymentStatus, Label : 'Payment Status' }
    ]
  },
  UI.Facets : [
    {
      $Type  : 'UI.ReferenceFacet',
      ID     : 'PaymentGeneral',
      Label  : 'Payment Information',
      Target : '@UI.FieldGroup#General'
    }
  ],
  Capabilities.InsertRestrictions : { Insertable : true },
  Capabilities.UpdateRestrictions : { Updatable  : true },
  Capabilities.DeleteRestrictions : { Deletable  : true }
);