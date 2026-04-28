sap.ui.define([
    "sap/fe/test/JourneyRunner",
	"o2c/orderitems/test/integration/pages/OrderItemsList",
	"o2c/orderitems/test/integration/pages/OrderItemsObjectPage"
], function (JourneyRunner, OrderItemsList, OrderItemsObjectPage) {
    'use strict';

    var runner = new JourneyRunner({
        launchUrl: sap.ui.require.toUrl('o2c/orderitems') + '/test/flp.html#app-preview',
        pages: {
			onTheOrderItemsList: OrderItemsList,
			onTheOrderItemsObjectPage: OrderItemsObjectPage
        },
        async: true
    });

    return runner;
});

