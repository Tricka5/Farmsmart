"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.UpdateCashBookDto = void 0;
const mapped_types_1 = require("@nestjs/mapped-types");
const create_cash_book_dto_1 = require("./create-cash-book.dto");
class UpdateCashBookDto extends (0, mapped_types_1.PartialType)(create_cash_book_dto_1.CreateCashBookDto) {
}
exports.UpdateCashBookDto = UpdateCashBookDto;
//# sourceMappingURL=update-cash-book.dto.js.map