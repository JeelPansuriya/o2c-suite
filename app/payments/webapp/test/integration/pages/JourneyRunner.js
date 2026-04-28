sap.ui.define([
    "sap/fe/test/JourneyRunner",
	"o2c/payments/test/integration/pages/PaymentsList",
	"o2c/payments/test/integration/pages/PaymentsObjectPage"
], function (JourneyRunner, PaymentsList, PaymentsObjectPage) {
    'use strict';

    var runner = new JourneyRunner({
        launchUrl: sap.ui.require.toUrl('o2c/payments') + '/test/flp.html#app-preview',
        pages: {
			onThePaymentsList: PaymentsList,
			onThePaymentsObjectPage: PaymentsObjectPage
        },
        async: true
    });

    return runner;
});

