sap.ui.define([
    "sap/ui/core/Fragment",
    "sap/m/MessageToast",
    "sap/m/Button"
], function(Fragment, MessageToast, Button) {
    "use strict";

    return {
        onInit: function() {
            var oView = this.getView();
            var oController = this;
            
            // Get the ObjectPage header
            var oObjectPageLayout = oView.byId("fe::ObjectPage");
            if (!oObjectPageLayout) {
                return;
            }

            // Create and add the "Add Item" button to the header
            var oButton = new Button({
                text: "Add Item",
                type: "Emphasized",
                press: function() {
                    oController.onOpenAddItemDialog();
                }
            });

            var oHeaderActions = oView.getContent()[0];
            if (oHeaderActions && oHeaderActions.getHeaderActions) {
                oHeaderActions.getHeaderActions().insertButton(oButton);
            }
        },

        onOpenAddItemDialog: function() {
            var oView = this.getView();
            var that = this;
            if (!this._pDialog) {
                this._pDialog = Fragment.load({
                    name: "o2c.orders.extension.fragments.OrderItemsDialog",
                    controller: this
                }).then(function(oDialog) {
                    oView.addDependent(oDialog);
                    that._oDialog = oDialog;
                    return oDialog;
                });
            }
            this._pDialog.then(function(oDialog) {
                oDialog.open();
            });
        },

        onCloseDialog: function() {
            if (this._oDialog) this._oDialog.close();
        },

        onAddItem: function() {
            var oDialog = this._oDialog;
            var sProduct = oDialog.byId("productSelect").getSelectedKey();
            var iQty = parseInt(oDialog.byId("quantityInput").getValue(), 10) || 1;
            var oView = this.getView();
            var oContext = oView.getBindingContext();
            if (!oContext) {
                MessageToast.show("No order context available");
                return;
            }
            
            var that = this;
            var sPath = oContext.getPath();
            var oModel = oView.getModel();
            
            var oData = {
                productID: sProduct,
                quantity: iQty
            };
            
            // Create item through the order's items association (respects draft)
            oModel.create(sPath + "/items", oData, {
                success: function() {
                    MessageToast.show("Item added successfully");
                    oDialog.close();
                    // Refresh the binding to show new item
                    oContext.requestObject().then(function() {
                        oView.getModel().refresh(true);
                    });
                },
                error: function(oError) {
                    var sMsg = "Error adding item";
                    if (oError.responseJSON && oError.responseJSON.error && oError.responseJSON.error.message) {
                        sMsg = oError.responseJSON.error.message;
                    }
                    MessageToast.show(sMsg);
                }
            });
        }
    };
});
