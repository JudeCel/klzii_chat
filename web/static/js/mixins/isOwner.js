const IsOwnerMixin = {
  isOwner(givenId) {
    const { id } = this.props.currentUser;
    return(id == givenId)
  }
}

export default IsOwnerMixin;
