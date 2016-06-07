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
  hasPermissions(parent, child) {
    return _returnPermission(this.props.currentUser.permissions, parent, child) || false;
  }
}

export default validations;
