using { o2c as db } from '../db/schema';

service O2CService @(path: '/odata/v4/o2c') @(requires: 'authenticated-user') {

  @odata.draft.enabled
  entity Customers as projection on db.Customers;

  @odata.draft.enabled
  entity Products as projection on db.Products;

  @odata.draft.enabled
  entity Orders as projection on db.Orders;

  @odata.draft.enabled
  entity OrderItems as projection on db.OrderItems;

  @odata.draft.enabled
  entity Approvals as projection on db.Approvals;

  @odata.draft.enabled
  entity Invoices as projection on db.Invoices;

  @odata.draft.enabled
  entity Payments as projection on db.Payments;
}
