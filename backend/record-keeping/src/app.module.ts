import { Module } from '@nestjs/common';
import { AppController } from './app.controller';
import { AppService } from './app.service';
import { MessageModule } from './message/message.module';
import { UsersModule } from './users/users.module';
import { CashBookModule } from './cash-book/cash-book.module';
import { InboxModule } from './inbox/inbox.module';
import { InboxparticipantsModule } from './inboxparticipants/inboxparticipants.module';
import { StartConversaation } from './startcova.controller';
import { StartconversationModule } from './startconversation/startconversation.module';
import { InboxparticipantsService } from './inboxparticipants/inboxparticipants.service';
import { InboxService } from './inbox/inbox.service';
import { LedgerModule } from './ledger/ledger.module';
import { LedgerEntryModule } from './ledger-entry/ledger-entry.module';
import { EmailModule } from './email/email.module';
import { OtpModule } from './otp/otp.module';
import { UserAunthenticationModule } from './user-aunthentication/user-aunthentication.module';

@Module({
  imports: [MessageModule, UsersModule, CashBookModule, InboxModule, InboxparticipantsModule, StartconversationModule, LedgerModule, LedgerEntryModule, EmailModule, OtpModule, UserAunthenticationModule],
  controllers: [AppController,StartConversaation],
  providers: [AppService,InboxparticipantsService,InboxService],
})
export class AppModule {}
