import { CashBookService } from './cash-book.service';
import { CreateCashBookDto } from './dto/create-cash-book.dto';
import { UpdateCashBookDto } from './dto/update-cash-book.dto';
export declare class CashBookController {
    private readonly cashBookService;
    constructor(cashBookService: CashBookService);
    create(createCashBookDto: CreateCashBookDto): string;
    findAll(): string;
    findOne(id: string): string;
    update(id: string, updateCashBookDto: UpdateCashBookDto): string;
    remove(id: string): string;
}
