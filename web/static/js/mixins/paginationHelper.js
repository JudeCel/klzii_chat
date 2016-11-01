import React from 'react';

const paginationHelper = {
  initPaginatorButton(className) {
    let { page } = this.state;

    var itemsPaginator = document.getElementById(className);
    if (itemsPaginator) {
      var el = itemsPaginator.getElementsByClassName('pagination')[0];
      if (el && el.childNodes.length > 0) {
        var oldElements = itemsPaginator.getElementsByClassName('paginatorFakeButton');
        for(var i=oldElements.length-1; i>=0; i--) {
          el.removeChild(oldElements[i]);
        }
        if (el.innerHTML.indexOf('⟨') < 0) {
          let button = this.createPaginatorButtonElement('⟨');
          el.insertBefore(button, el.firstChild);
        }
        if (el.innerHTML.indexOf('«') < 0) {
          let button = this.createPaginatorButtonElement('«');
          el.insertBefore(button, el.firstChild);
        }
        if (el.innerHTML.indexOf('⟩') < 0) {
          let button = this.createPaginatorButtonElement('⟩');
          el.appendChild(button);
        }
        if (el.innerHTML.indexOf('»') < 0) {
          let button = this.createPaginatorButtonElement('»');
          el.appendChild(button);
        }
      }
    }
  },
  createPaginatorButtonElement(text) {
    let liEl = document.createElement("li");
    let aEl = document.createElement("a");
    aEl.innerHTML = text;
    liEl.appendChild(aEl);
    liEl.className = "paginatorFakeButton";
    liEl.className += " unactive"
    return liEl;
  },
}

export default paginationHelper;
