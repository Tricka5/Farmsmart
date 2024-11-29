"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.UpdateLedgerDto = void 0;
const mapped_types_1 = require("@nestjs/mapped-types");
const create_ledger_dto_1 = require("./create-ledger.dto");
class UpdateLedgerDto extends (0, mapped_types_1.PartialType)(create_ledger_dto_1.CreateLedgerDto) {
}
exports.UpdateLedgerDto = UpdateLedgerDto;
//# sourceMappingURL=update-ledger.dto.js.map