function _returnPermission(permissions, parent, child) {
  if(permissions) {
    if(child) {
      return permissions[parent][child];
    }
    else {
      return permissions[parent];
    }
  }
}

const validations = {
  isOwner(givenId) {
    return(this.props.currentUser.id == givenId)
  },
  hasPermissions(parent, child) {
    return _returnPermission(this.props.currentUser.permissions, parent, child) || false;
  },
  isFacilitator(member) {
    return member.role == 'facilitator';
  },
  isParticipant(member) {
    return member.role == 'participant';
  }
}

export default validations;
