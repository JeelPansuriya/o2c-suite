sap.ui.define([
    "sap/fe/test/JourneyRunner",
	"o2c/analytics/test/integration/pages/OrdersList",
	"o2c/analytics/test/integration/pages/OrdersObjectPage",
	"o2c/analytics/test/integration/pages/OrderItemsObjectPage"
], function (JourneyRunner, OrdersList, OrdersObjectPage, OrderItemsObjectPage) {
    'use strict';

    var runner = new JourneyRunner({
        launchUrl: sap.ui.require.toUrl('o2c/analytics') + '/test/flp.html#app-preview',
        pages: {
			onTheOrdersList: OrdersList,
			onTheOrdersObjectPage: OrdersObjectPage,
			onTheOrderItemsObjectPage: OrderItemsObjectPage
        },
        async: true
    });

    return runner;
});

