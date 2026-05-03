sap.ui.define([
    "sap/ui/core/mvc/Controller",
    "sap/ui/model/json/JSONModel"
], function (Controller, JSONModel) {
    "use strict";

    return Controller.extend("o2c.reports.controller.Report", {
        onInit: function () {
            const oData = {
                kpi: {
                    orders: "20",
                    revenue: "$10000",
                    customers: "15",
                    payments: "15"
                },
                sales: [
                    { month: "January", value: 1200 },
                    { month: "February", value: 1540 },
                    { month: "March", value: 1920 },
                    { month: "April", value: 2380 },
                    { month: "May", value: 2650 }
                ],
                status: [
                    { status: "Completed", count: 1050 },
                    { status: "In Progress", count: 720 },
                    { status: "Pending", count: 430 },
                    { status: "On Hold", count: 180 },
                    { status: "Cancelled", count: 71 }
                ],
                categories: [
                    { category: "Electronics", value: 850 },
                    { category: "Software", value: 720 },
                    { category: "Furniture", value: 580 },
                    { category: "Services", value: 560 },
                    { category: "Supplies", value: 340 }
                ],
                paymentMethods: [
                    { method: "Credit Card", count: 680 },
                    { method: "Bank Transfer", count: 520 },
                    { method: "Digital Wallet", count: 380 },
                    { method: "Check/Other", count: 276 }
                ]
            };

            this.getView().setModel(new JSONModel(oData));
        }
    });
});
