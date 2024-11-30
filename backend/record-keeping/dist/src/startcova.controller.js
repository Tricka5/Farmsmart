"use strict";
var __decorate = (this && this.__decorate) || function (decorators, target, key, desc) {
    var c = arguments.length, r = c < 3 ? target : desc === null ? desc = Object.getOwnPropertyDescriptor(target, key) : desc, d;
    if (typeof Reflect === "object" && typeof Reflect.decorate === "function") r = Reflect.decorate(decorators, target, key, desc);
    else for (var i = decorators.length - 1; i >= 0; i--) if (d = decorators[i]) r = (c < 3 ? d(r) : c > 3 ? d(target, key, r) : d(target, key)) || r;
    return c > 3 && r && Object.defineProperty(target, key, r), r;
};
var __metadata = (this && this.__metadata) || function (k, v) {
    if (typeof Reflect === "object" && typeof Reflect.metadata === "function") return Reflect.metadata(k, v);
};
var __param = (this && this.__param) || function (paramIndex, decorator) {
    return function (target, key) { decorator(target, key, paramIndex); }
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.StartConversaation = void 0;
const common_1 = require("@nestjs/common");
const inboxparticipants_service_1 = require("./inboxparticipants/inboxparticipants.service");
const inbox_service_1 = require("./inbox/inbox.service");
const create_user_dto_1 = require("./users/dto/create-user.dto");
let StartConversaation = class StartConversaation {
    constructor(inboxParticipantsService, inboxService) {
        this.inboxParticipantsService = inboxParticipantsService;
        this.inboxService = inboxService;
    }
    async startCoversation(userData) {
        console.log('firstly', userData);
        const { firstuserid, seconduserid } = userData;
        console.log('here,', userData);
        try {
            const result = await this.inboxService.createEntry(firstuserid);
            const { inboxid: inboxid, lastmessage: last_message } = result;
            const inboxParticipant = {
                firstuserid,
                seconduserid,
                inboxid,
            };
            const AddFirstParticipant = await this.inboxParticipantsService.addParticipant(inboxParticipant);
            return {
                AddFirstParticipant,
            };
        }
        catch (error) {
            console.error('error stating conversation', error);
            throw new common_1.HttpException('failed', common_1.HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }
};
exports.StartConversaation = StartConversaation;
__decorate([
    (0, common_1.Post)('startconva'),
    __param(0, (0, common_1.Body)()),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [create_user_dto_1.CreateUserDto]),
    __metadata("design:returntype", Promise)
], StartConversaation.prototype, "startCoversation", null);
exports.StartConversaation = StartConversaation = __decorate([
    (0, common_1.Controller)('creatingnewconversation'),
    __metadata("design:paramtypes", [inboxparticipants_service_1.InboxparticipantsService,
        inbox_service_1.InboxService])
], StartConversaation);
//# sourceMappingURL=startcova.controller.js.map