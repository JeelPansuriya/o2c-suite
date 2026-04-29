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

@title : 'Customers'
entity Customers : cuid, managed {
  customerID   : String(20)  @mandatory @title : 'Customer ID';
  customerName : String(100) @mandatory @title : 'Customer Name';
  email        : String(100)            @title : 'Email';
  phone        : String(30)             @title : 'Phone';
  address      : String(255)            @title : 'Address';
  creditLimit  : Decimal(15,2) default 0 @title : 'Credit Limit';
  usedCredit   : Decimal(15,2) default 0 @title : 'Used Credit';
  status       : MasterStatus default 'Active' @title : 'Status';

  orders       : Association to many Orders on orders.customerID = $self.customerID;
}

@title : 'Products'
entity Products : cuid, managed {
  productID   : String(20)  @mandatory @title : 'Product ID';
  productName : String(100) @mandatory @title : 'Product Name';
  category    : String(50)             @title : 'Category';
  price       : Decimal(15,2) default 0 @title : 'Price';
  stock       : Integer default 0       @title : 'Stock';
  status      : MasterStatus default 'Active' @title : 'Status';

  orderItems  : Association to many OrderItems on orderItems.productID = $self.productID;
}

@title : 'Sales Orders'
entity Orders : cuid, managed {
  orderID      : String(20) @mandatory @title : 'Order ID';
  customerID   : String(20) @mandatory @title : 'Customer';
  orderDate    : Date       @mandatory @title : 'Order Date';
  totalAmount  : Decimal(15,2) default 0 @title : 'Total Amount';
  creditStatus : CreditStatus default 'Pending' @title : 'Credit Status';
  orderStatus  : OrderStatus  default 'Open'    @title : 'Order Status';

  customer     : Association to Customers on customer.customerID = $self.customerID;
  items        : Association to many OrderItems on items.orderID = $self.orderID;
  approvals    : Association to many Approvals  on approvals.orderID = $self.orderID;
  invoices     : Association to many Invoices   on invoices.orderID  = $self.orderID;
}

@title : 'Order Items'
entity OrderItems : cuid, managed {
  itemID    : String(20) @mandatory @title : 'Item ID';
  orderID   : String(20) @mandatory @title : 'Order';
  productID : String(20) @mandatory @title : 'Product';
  quantity  : Integer default 1         @title : 'Quantity';
  unitPrice : Decimal(15,2) default 0   @title : 'Unit Price';
  itemTotal : Decimal(15,2) default 0   @title : 'Item Total';

  order   : Association to Orders   on order.orderID     = $self.orderID;
  product : Association to Products on product.productID = $self.productID;
}

@title : 'Credit Approvals'
entity Approvals : cuid, managed {
  approvalID : String(20) @mandatory @title : 'Approval ID';
  orderID    : String(20) @mandatory @title : 'Order';
  decision   : ApprovalDecision default 'Pending' @title : 'Decision';
  remarks    : String(255)  @title : 'Remarks';
  approvedBy : String(100)  @title : 'Approved By';
  approvedOn : DateTime     @title : 'Approved On';

  order : Association to Orders on order.orderID = $self.orderID;
}

@title : 'Invoices'
entity Invoices : cuid, managed {
  invoiceID     : String(20) @mandatory @title : 'Invoice ID';
  orderID       : String(20) @mandatory @title : 'Order';
  invoiceDate   : Date       @mandatory @title : 'Invoice Date';
  amount        : Decimal(15,2) default 0 @title : 'Amount';
  dueDate       : Date          @title : 'Due Date';
  invoiceStatus : InvoiceStatus default 'Open' @title : 'Invoice Status';

  order    : Association to Orders   on order.orderID       = $self.orderID;
  payments : Association to many Payments on payments.invoiceID = $self.invoiceID;
}

@title : 'Payments'
entity Payments : cuid, managed {
  paymentID     : String(20) @mandatory @title : 'Payment ID';
  invoiceID     : String(20) @mandatory @title : 'Invoice';
  amountPaid    : Decimal(15,2) default 0 @title : 'Amount Paid';
  paymentDate   : Date          @title : 'Payment Date';
  paymentMode   : PaymentMode   @title : 'Payment Mode';
  paymentStatus : PaymentStatus default 'Pending' @title : 'Payment Status';

  invoice : Association to Invoices on invoice.invoiceID = $self.invoiceID;
}