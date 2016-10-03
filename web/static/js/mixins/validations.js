const validations = {
  hasFieldsMissing(object, fields) {
    let missing = [];
    fields.map((field) => {
      if(!object[field]) {
        missing.push(field);
      }
    });

    return missing.length > 0 ? missing : false;
  },
  isOwner(givenId) {
    return(this.props.currentUser.id == givenId)
  },
  hasPermission(keys) {
    let permission = this.props.currentUser.permissions;
    if(!permission) {
      return false;
    }

    for(var i in keys) {
      permission = permission[keys[i]];

      if(!permission && keys.length != i + 1) {
        return false;
      }
    }

    return permission || false;
  },
  isFacilitator(member) {
    return member.role == 'facilitator';
  },
  isParticipant(member) {
    return member.role == 'participant';
  }
}

export default validations;
