module.exports = (srv) => {

  srv.before('CREATE', 'Orders', async (req) => {
    const { customerID, totalAmount } = req.data;

    // Validate required fields
    if (!customerID) {
      req.error(400, 'Customer is mandatory');
    }

    if (!totalAmount || totalAmount <= 0) {
      req.error(400, 'Total amount must be greater than 0');
    }

    // Fetch customer
    const customer = await SELECT.one.from('Customers')
      .where({ customerID });
    
    if (!customer) {
      req.error(400, 'Customer does not exist');
    }

    // Credit check
    if ((customer.usedCredit || 0) + totalAmount > customer.creditLimit) {
      req.error(400, 'Credit limit exceeded');
    }

  });

};