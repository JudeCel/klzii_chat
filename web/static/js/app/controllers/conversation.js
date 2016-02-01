function ConversationControler($scope, channel) {
  initSocketEvents();
  $scope.messages = [];
  $scope.newMesage = "";

  $scope.sendEntry = function () {
    if (this.text.length > 0) {
      addNewMessge(this.text);
    }
    this.text = "";
  }

  function appendNewMessage(message) {
    $scope.$apply(() => {
      $scope.messages.push(message)
    });
  }

  function addNewMessge(message) {
    channel.push("new_message", payload(message))
      .receive("error", (error) => { console.log(error) });
  }

  function initSocketEvents() {
    channel.on("new_message", (res) => {
      appendNewMessage(res);
    });
  }

  function payload(message) {
    return { body: message, time: new Date()}
  }
};

export default ConversationControler
