namespace o2c;

using { cuid, managed } from '@sap/cds/common';

type MasterStatus : String(20) enum {
  Active;
  Inactive;
  Blocked;
}

type CreditStatus : String(20) enum {
  Pending;
  Approved;
  Rejected;
}

type OrderStatus : String(20) enum {
  Open;
  Blocked;
  Released;
  Delivered;
  Cancelled;
  Invoiced;
  Paid;
}

type ApprovalDecision : String(20) enum {
  Pending;
  Approved;
  Rejected;
}

type InvoiceStatus : String(20) enum {
  Open;
  Overdue;
  Paid;
  Cancelled;
}

type PaymentMode : String(20) enum {
  Cash;
  Card;
  BankTransfer;
  UPI;
  Cheque;
}

type PaymentStatus : String(20) enum {
  Pending;
  Completed;
  Failed;
  Reversed;
}

entity Customers : cuid, managed {
  customerID   : String(20) @mandatory;
  customerName : String(100) @mandatory;
  email        : String(100);
  phone        : String(30);
  address      : String(255);
  creditLimit  : Decimal(15,2) default 0;
  usedCredit   : Decimal(15,2) default 0;
  status       : MasterStatus default 'Active';

  orders       : Association to many Orders on orders.customerID = $self.customerID;
}

entity Products : cuid, managed {
  productID   : String(20) @mandatory;
  productName : String(100) @mandatory;
  category    : String(50);
  price       : Decimal(15,2) default 0;
  stock       : Integer default 0;
  status      : MasterStatus default 'Active';

  orderItems  : Association to many OrderItems on orderItems.productID = $self.productID;
}

entity Orders : cuid, managed {
  orderID      : String(20) @mandatory;
  customerID   : String(20) @mandatory;
  orderDate    : Date @mandatory;
  totalAmount  : Decimal(15,2) default 0;
  creditStatus : CreditStatus default 'Pending';
  orderStatus  : OrderStatus default 'Open';

  customer     : Association to Customers on customer.customerID = $self.customerID;
  items        : Association to many OrderItems on items.orderID = $self.orderID;
  approvals    : Association to many Approvals on approvals.orderID = $self.orderID;
  invoices     : Association to many Invoices on invoices.orderID = $self.orderID;
}

entity OrderItems : cuid, managed {
  itemID     : String(20) @mandatory;
  orderID    : String(20) @mandatory;
  productID  : String(20) @mandatory;
  quantity   : Integer default 1;
  unitPrice  : Decimal(15,2) default 0;
  itemTotal  : Decimal(15,2) default 0;

  order      : Association to Orders on order.orderID = $self.orderID;
  product    : Association to Products on product.productID = $self.productID;
}

entity Approvals : cuid, managed {
  approvalID : String(20) @mandatory;
  orderID    : String(20) @mandatory;
  decision   : ApprovalDecision default 'Pending';
  remarks    : String(255);
  approvedBy : String(100);
  approvedOn : DateTime;

  order      : Association to Orders on order.orderID = $self.orderID;
}

entity Invoices : cuid, managed {
  invoiceID     : String(20) @mandatory;
  orderID       : String(20) @mandatory;
  invoiceDate   : Date @mandatory;
  amount        : Decimal(15,2) default 0;
  dueDate       : Date;
  invoiceStatus : InvoiceStatus default 'Open';

  order         : Association to Orders on order.orderID = $self.orderID;
  payments      : Association to many Payments on payments.invoiceID = $self.invoiceID;
}

entity Payments : cuid, managed {
  paymentID     : String(20) @mandatory;
  invoiceID     : String(20) @mandatory;
  amountPaid    : Decimal(15,2) default 0;
  paymentDate   : Date;
  paymentMode   : PaymentMode;
  paymentStatus : PaymentStatus default 'Pending';

  invoice       : Association to Invoices on invoice.invoiceID = $self.invoiceID;
}
