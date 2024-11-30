import { InboxService } from "src/inbox/inbox.service";
import { InboxparticipantsService } from "src/inboxparticipants/inboxparticipants.service";
import { CreateUserDto } from "src/users/dto/create-user.dto";
export declare class StartConversaation {
    private readonly inboxParticipantsService;
    private readonly inboxService;
    constructor(inboxParticipantsService: InboxparticipantsService, inboxService: InboxService);
    startCoversation(userData: CreateUserDto): Promise<{
        AddFirstParticipant: {
            inboxid: number;
            firstuserid: number;
            seconduserid: number;
        };
    }>;
}
