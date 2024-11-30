"use strict";
var __decorate = (this && this.__decorate) || function (decorators, target, key, desc) {
    var c = arguments.length, r = c < 3 ? target : desc === null ? desc = Object.getOwnPropertyDescriptor(target, key) : desc, d;
    if (typeof Reflect === "object" && typeof Reflect.decorate === "function") r = Reflect.decorate(decorators, target, key, desc);
    else for (var i = decorators.length - 1; i >= 0; i--) if (d = decorators[i]) r = (c < 3 ? d(r) : c > 3 ? d(target, key, r) : d(target, key)) || r;
    return c > 3 && r && Object.defineProperty(target, key, r), r;
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.AppModule = void 0;
const common_1 = require("@nestjs/common");
const app_controller_1 = require("./app.controller");
const app_service_1 = require("./app.service");
const message_module_1 = require("./message/message.module");
const users_module_1 = require("./users/users.module");
const cash_book_module_1 = require("./cash-book/cash-book.module");
const inbox_module_1 = require("./inbox/inbox.module");
const inboxparticipants_module_1 = require("./inboxparticipants/inboxparticipants.module");
const startcova_controller_1 = require("./startcova.controller");
const startconversation_module_1 = require("./startconversation/startconversation.module");
const inboxparticipants_service_1 = require("./inboxparticipants/inboxparticipants.service");
const inbox_service_1 = require("./inbox/inbox.service");
const ledger_module_1 = require("./ledger/ledger.module");
const ledger_entry_module_1 = require("./ledger-entry/ledger-entry.module");
const email_module_1 = require("./email/email.module");
const otp_module_1 = require("./otp/otp.module");
const user_aunthentication_module_1 = require("./user-aunthentication/user-aunthentication.module");
const crop_record_module_1 = require("./crop-record/crop-record.module");
const live_stock_module_1 = require("./live-stock/live-stock.module");
const crop_module_1 = require("./crop/crop.module");
const live_stock_record_module_1 = require("./live-stock-record/live-stock-record.module");
const cloudinary_module_1 = require("./cloudinary/cloudinary.module");
const websocket_module_1 = require("./websocket/websocket.module");
let AppModule = class AppModule {
};
exports.AppModule = AppModule;
exports.AppModule = AppModule = __decorate([
    (0, common_1.Module)({
        imports: [message_module_1.MessageModule, users_module_1.UsersModule, cash_book_module_1.CashBookModule, inbox_module_1.InboxModule, inboxparticipants_module_1.InboxparticipantsModule, startconversation_module_1.StartconversationModule, ledger_module_1.LedgerModule, ledger_entry_module_1.LedgerEntryModule, email_module_1.EmailModule, otp_module_1.OtpModule, user_aunthentication_module_1.UserAunthenticationModule, crop_record_module_1.CropRecordModule, live_stock_module_1.LiveStockModule, crop_module_1.CropModule, live_stock_record_module_1.LiveStockRecordModule, cloudinary_module_1.CloudinaryModule,
            websocket_module_1.WebSocketModule
        ],
        controllers: [app_controller_1.AppController, startcova_controller_1.StartConversaation],
        providers: [app_service_1.AppService, inboxparticipants_service_1.InboxparticipantsService, inbox_service_1.InboxService],
    })
], AppModule);
//# sourceMappingURL=app.module.js.map