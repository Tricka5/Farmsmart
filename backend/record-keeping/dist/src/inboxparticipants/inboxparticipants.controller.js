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
exports.InboxparticipantsController = void 0;
const common_1 = require("@nestjs/common");
const inboxparticipants_service_1 = require("./inboxparticipants.service");
let InboxparticipantsController = class InboxparticipantsController {
    constructor(inboxparticipantsService) {
        this.inboxparticipantsService = inboxparticipantsService;
    }
    async getUserById(inboxidparticipantid) {
        const inbox_participant_id = Number(inboxidparticipantid);
        const user = await this.inboxparticipantsService.getInboxParticipant(inbox_participant_id);
        if (!user) {
            throw new common_1.HttpException(`user ${inbox_participant_id} not found`, common_1.HttpStatus.NOT_FOUND);
        }
        return user;
    }
    async getFriends(currentuserid) {
        const users = await this.inboxparticipantsService.getFriends(currentuserid);
        return users;
    }
    async getAllUsers(id) {
        const userIdCurrent = parseInt(id, 10);
        if (isNaN(userIdCurrent)) {
            throw new common_1.BadRequestException('Invalid user ID');
        }
        const result = await this.inboxparticipantsService.getFriends(userIdCurrent);
        const data = result.map(item => item.secondinboxid);
        const users = await this.inboxparticipantsService.getUserFromUsersTable(data);
        return users;
    }
    async getCurrentInbox(params) {
        try {
            const { otheruser, currentuser } = params;
            return await this.inboxparticipantsService.getCurrentInbox(otheruser, currentuser);
        }
        catch (error) {
            console.error('Error fetching current inbox hahaha:', error);
            throw new common_1.HttpException('Internal server error hahaha', common_1.HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }
};
exports.InboxparticipantsController = InboxparticipantsController;
__decorate([
    (0, common_1.Get)(':inboxparticipantid'),
    __param(0, (0, common_1.Param)('inboxparticipantid')),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [String]),
    __metadata("design:returntype", Promise)
], InboxparticipantsController.prototype, "getUserById", null);
__decorate([
    (0, common_1.Get)(':currentuserid/friends'),
    __param(0, (0, common_1.Param)()),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [Number]),
    __metadata("design:returntype", Promise)
], InboxparticipantsController.prototype, "getFriends", null);
__decorate([
    (0, common_1.Get)(':id/chat'),
    __param(0, (0, common_1.Param)('id')),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [String]),
    __metadata("design:returntype", Promise)
], InboxparticipantsController.prototype, "getAllUsers", null);
__decorate([
    (0, common_1.Get)('currentinbox/:otheruser/:currentuser'),
    __param(0, (0, common_1.Param)()),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [Object]),
    __metadata("design:returntype", Promise)
], InboxparticipantsController.prototype, "getCurrentInbox", null);
exports.InboxparticipantsController = InboxparticipantsController = __decorate([
    (0, common_1.Controller)('inboxparticipants'),
    __metadata("design:paramtypes", [inboxparticipants_service_1.InboxparticipantsService])
], InboxparticipantsController);
//# sourceMappingURL=inboxparticipants.controller.js.map