#! /bin/bash
#
# Output all groups and their members
#
# 15.jan.2016	ykim
#

gam () {
	"$HOME/bin/gam/gam" "$@"
}

ALLG=$(gam print groups | egrep -v "^\+|Email")

case $1 in
-g)	echo "$ALLG" | fmt -1 | sort; exit ;;
esac

[ -z "$ALLG" ] && echo "Null list of groups" && exit 1

for g in $ALLG
do
	MEMBERS=$(gam whatis $g | awk '$1 == "directMembersCount:" { print $2 }')
	echo "$g, $MEMBERS"
done

#########################
# % gam whatis techops-it
# techops-it@firstup.io is not a user...
# techops-it@firstup.io is not a user alias...
# techops-it@firstup.io is a group
# 
# 
# Group Settings:
#  id: 02szc72q2kdf05l
#  email: techops-it@firstup.io
#  name: techops-it
#  directMembersCount: 4
#  description: Corp IT Technical Operation
#  adminCreated: True
#  nonEditableAliases:
#   techops-it@firstup.io.test-google-a.com
#  whoCanJoin: CAN_REQUEST_TO_JOIN
#  whoCanViewMembership: ALL_MEMBERS_CAN_VIEW
#  whoCanViewGroup: ALL_MEMBERS_CAN_VIEW
#  whoCanInvite: ALL_MANAGERS_CAN_INVITE
#  whoCanAdd: ALL_MANAGERS_CAN_ADD
#  allowExternalMembers: false
#  whoCanPostMessage: ANYONE_CAN_POST
#  allowWebPosting: true
#  maxMessageBytes: 26214400
#  isArchived: false
#  archiveOnly: false
#  messageModerationLevel: MODERATE_NONE
#  spamModerationLevel: MODERATE
#  replyTo: REPLY_TO_IGNORE
#  customReplyTo:
#  includeCustomFooter: false
#  customFooterText:
#  sendMessageDenyNotification: false
#  defaultMessageDenyNotificationText:
#  showInGroupDirectory: true
#  allowGoogleCommunication: false
#  membersCanPostAsTheGroup: false
#  messageDisplayFont: DEFAULT_FONT
#  includeInGlobalAddressList: true
#  whoCanLeaveGroup: ALL_MEMBERS_CAN_LEAVE
#  whoCanContactOwner: ANYONE_CAN_CONTACT
#  whoCanAddReferences: NONE
#  whoCanAssignTopics: NONE
#  whoCanUnassignTopic: NONE
#  whoCanTakeTopics: NONE
#  whoCanMarkDuplicate: NONE
#  whoCanMarkNoResponseNeeded: NONE
#  whoCanMarkFavoriteReplyOnAnyTopic: NONE
#  whoCanMarkFavoriteReplyOnOwnTopic: NONE
#  whoCanUnmarkFavoriteReplyOnAnyTopic: NONE
#  whoCanEnterFreeFormTags: NONE
#  whoCanModifyTagsAndCategories: NONE
#  favoriteRepliesOnTop: true
#  whoCanApproveMembers: ALL_MANAGERS_CAN_APPROVE
#  whoCanBanUsers: OWNERS_AND_MANAGERS
#  whoCanModifyMembers: OWNERS_AND_MANAGERS
#  whoCanApproveMessages: OWNERS_AND_MANAGERS
#  whoCanDeleteAnyPost: OWNERS_AND_MANAGERS
#  whoCanDeleteTopics: OWNERS_AND_MANAGERS
#  whoCanLockTopics: OWNERS_AND_MANAGERS
#  whoCanMoveTopicsIn: OWNERS_AND_MANAGERS
#  whoCanMoveTopicsOut: OWNERS_AND_MANAGERS
#  whoCanPostAnnouncements: OWNERS_AND_MANAGERS
#  whoCanHideAbuse: NONE
#  whoCanMakeTopicsSticky: NONE
#  whoCanModerateMembers: OWNERS_AND_MANAGERS
#  whoCanModerateContent: OWNERS_AND_MANAGERS
#  whoCanAssistContent: NONE
#  customRolesEnabledForSettingsToBeMerged: false
#  enableCollaborativeInbox: false
#  whoCanDiscoverGroup: ALL_IN_DOMAIN_CAN_DISCOVER
#  defaultSender: DEFAULT_SELF
# Members:
#  member: diondre.jordan@firstup.io (user)
#  member: tawfiq.momin@firstup.io (user)
#  member: vi.tran@firstup.io (user)
#  member: yoon.kim@firstup.io (user)
# Total 4 users in group
