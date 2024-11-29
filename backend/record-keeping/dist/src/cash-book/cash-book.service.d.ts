import { CreateCashBookDto } from './dto/create-cash-book.dto';
import { UpdateCashBookDto } from './dto/update-cash-book.dto';
export declare class CashBookService {
    create(createCashBookDto: CreateCashBookDto): string;
    findAll(): string;
    findOne(id: number): string;
    update(id: number, updateCashBookDto: UpdateCashBookDto): string;
    remove(id: number): string;
}
