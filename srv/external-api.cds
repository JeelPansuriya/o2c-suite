service ExternalApiService @(path: '/odata/v4/external-api')  {

  entity ApiCustomers {
    key CustomerId   : String(20);
        CustomerName : String(100);
        Email        : String(100);
        Phone        : String(30);
        Address      : String(255);
        CreditLimit  : Decimal(15,2);
        UsedCredit   : Decimal(15,2);
        Status       : String(20);
  }

  entity ApiProducts {
    key ProductId   : String(20);
        ProductName : String(100);
        Category    : String(50);
        Price       : Decimal(15,2);
        Currency    : String(5);
        Stock       : Integer;
        Status      : String(20);
  }
}
