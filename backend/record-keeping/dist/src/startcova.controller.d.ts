import { InboxparticipantsService } from "./inboxparticipants/inboxparticipants.service";
import { InboxService } from "./inbox/inbox.service";
import { CreateUserDto } from "./users/dto/create-user.dto";
export declare class StartConversaation {
    private readonly inboxParticipantsService;
    private readonly inboxService;
    constructor(inboxParticipantsService: InboxparticipantsService, inboxService: InboxService);
    startCoversation(userData: CreateUserDto): Promise<{
        AddFirstParticipant: {
            userid: number;
            inboxid: number;
        };
        AddSecondParticipantt: {
            userid: number;
            inboxid: number;
        };
    }>;
}
