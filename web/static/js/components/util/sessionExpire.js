import React       from 'react';
import ReactDOM    from 'react-dom';

const SessionExpire = {
  expireTime: 4 * 3600 * 1000, // 4h
  //expireTime: 10 * 1000, // 10s
  dialogTimeout: 28, // 28s
  currentDialogTimeout: -1,
  modalInited: false,

  init() {
    this.scheduleNextSessionTimeout();
  },

  scheduleNextSessionTimeout() {
    setTimeout(this.showExpireDialog, this.expireTime, this);
  },

  doLogout() {
    location.href = "/logout_all";
  },

  doContinue(self) {
    self.currentDialogTimeout = -1;
    self.scheduleNextSessionTimeout();
    document.getElementById("sessionExpireModal").style.display = 'none';
  },

  dialogTimeoutCountdown(self) {
    if (self.currentDialogTimeout >= 0) {
      self.currentDialogTimeout--;
      if (self.currentDialogTimeout == 0) {
        self.doLogout();
      } else {
        setTimeout(self.dialogTimeoutCountdown, 1000, self);
        document.querySelector("#sessionExpireModal #dialogTimeout").innerText = self.currentDialogTimeout.toString();
      }
    }
  },

  initModal(self) {
    let modal = '<div id="sessionExpireModal" class="modal fade" role="dialog"> \
      <div class="modal-dialog sessionExpireModal"> \
        <div class="modal-content"> \
          <div class="modal-header"> \
            <h2 class="modal-title text-center">This session is about to expire</h2> \
          </div> \
          <div class="modal-body"> \
            <div class="form-group"> \
                <center>Your session will be locked in <span id="dialogTimeout">' + self.dialogTimeout.toString() + '</span> seconds. Do you want to continue your session?</center> \
            </div> \
          </div> \
          <div class="modal-footer"> \
            <div type="button" class="btn btn-standart pull-left btn-red" role="button">No, Logout</div> \
            <div type="submit" class="btn btn-standart pull-right btn-green" role="button">Yes, keep working</div> \
          </div> \
        </div> \
      </div> \
    </div>';

    let parent = document.getElementsByTagName("body")[0];
    parent.insertAdjacentHTML('beforeend', modal);
  },

  showExpireDialog(self) {
    if (!self.modalInited) {
      self.initModal(self);
      self.modalInited = true;
    }

    document.getElementById("sessionExpireModal").style.display = 'block';
    self.currentDialogTimeout = self.dialogTimeout;

    document.querySelector("#sessionExpireModal .modal-footer .btn-red").onclick = function() {
      self.doLogout();
    };
    document.querySelector("#sessionExpireModal .modal-footer .btn-green").onclick = function() {
      self.doContinue(self);
    };
    setTimeout(self.dialogTimeoutCountdown, 1000, self);
  }

}

export default SessionExpire;
