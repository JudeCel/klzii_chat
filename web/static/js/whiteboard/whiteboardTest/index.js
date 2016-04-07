var app = angular.module('myApp', []);
app.controller('WhiteboardController', function($scope) {

  var vm = this;
  var v = new Whiteboard("svg");

  vm.addRect = function(filled) {
    v.addRect(filled);
  };

  vm.addCircle = function(filled) {
    v.addCircle(filled);
  };

  vm.addText = function() {
    v.addText("Whiteboard ROCKS");
  };

  vm.addImage = function() {
    v.addImage("http://www.diatomenterprises.com/Images/Backgrounds/main-header-bg.jpg", {x: 20, y: 20, width: 100, height: 100});
  }
  vm.addScribble = function(filled) {
    v.addScribble(filled);
  }
  vm.addLine = function(arrow) {
    v.addLine(arrow);
  }

  vm.delete = function() {
    v.deleteActive();
  }
});
