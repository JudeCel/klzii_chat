import React from 'react';
import {assert} from 'chai';
import undoHistoryFactory  from '../../web/static/js/components/whiteboard/actionHistory';

describe("testWhiteboard", ()=> {
  let step1Object = "one";
  let step2Object = "two";
  let step3Object = "three";
  let step4Object = ["four1", "four2", "four3"];

  let step5RedoObject = "five_redo";
  let step6RedoObject = "six_redo";
  let step7RedoObject = "seven_redo";

  before(function() {
  });
  after(function() {
  });

  it("Test Whiteboard undo history", () => {
    assert.equal(null, undoHistoryFactory.undoStepObject());
    //at this point we should have 0 steps in history
    assert.equal(0, undoHistoryFactory.getActionCount());

    undoHistoryFactory.processHistory(step1Object);
    undoHistoryFactory.processHistory(step2Object);
    undoHistoryFactory.processHistory(step3Object);
    undoHistoryFactory.processHistory(step4Object);
    //at this point we should have 4 steps in history
    assert.equal(4, undoHistoryFactory.getActionCount());
    assert.equal(step3Object, undoHistoryFactory.undoStepObject());
    assert.equal(step2Object, undoHistoryFactory.undoStepObject());
    //we didn't remove any object, still needs to be 4
    assert.equal(4, undoHistoryFactory.getActionCount());

    //add history step in the middle
    undoHistoryFactory.processHistory(step5RedoObject);
    //now history steps removed from 2nd step and added one more. Should be 3
    assert.equal(3, undoHistoryFactory.getActionCount());
    undoHistoryFactory.processHistory(step6RedoObject);
    undoHistoryFactory.processHistory(step7RedoObject);
    assert.equal(step6RedoObject, undoHistoryFactory.undoStepObject());
    assert.equal(step7RedoObject, undoHistoryFactory.redoStepObject());
    //reached end of history, next object should be null
    assert.equal(null, undoHistoryFactory.redoStepObject());
    assert.equal(null, undoHistoryFactory.redoStepObject());
    assert.equal(step6RedoObject, undoHistoryFactory.undoStepObject());
    assert.equal(step7RedoObject, undoHistoryFactory.redoStepObject());
  });

});
