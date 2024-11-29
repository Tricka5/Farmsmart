"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.UpdateInboxDto = void 0;
const mapped_types_1 = require("@nestjs/mapped-types");
const create_inbox_dto_1 = require("./create-inbox.dto");
class UpdateInboxDto extends (0, mapped_types_1.PartialType)(create_inbox_dto_1.CreateInboxDto) {
}
exports.UpdateInboxDto = UpdateInboxDto;
//# sourceMappingURL=update-inbox.dto.js.map