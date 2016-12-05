import React, {PropTypes} from 'react';
import Editor             from 'react-medium-editor';
import ReactDOM           from 'react-dom';
import { Picker } from 'emoji-mart';

const Board = React.createClass({
  getInitialState() {
    return {
      content: this.props.boardContent,
      options: {
        toolbar: { buttons: ['bold', 'italic', 'anchor'] }
      }
    };
  },
  strip(html) {
    var tmp = document.createElement("div");
    tmp.innerHTML = html;
    return tmp.textContent || tmp.innerText || "";
  },
  fixDeleteOnIE(newContent, editor) {
    if(window.navigator.userAgent.indexOf("MSIE") > 0 || !!window.navigator.userAgent.match(/Trident.*rv\:11\./)) {
      const { content } = this.state;
      if (newContent.length = content.length-1) {
        let pos = newContent.length;
        for (let i=0; i<newContent.length; i++) {
          if (content[i] != newContent[i]) {
            pos = i;
            break;
          }
        }
        editor.importSelection({start: pos, end: pos}, false);
      }
    }
  },
  onChange(newContent, editor) {
    const { content } = this.state;
    const maxLength = 150;
    let contentText = this.strip(content);
    let newContentText = this.strip(newContent);

    if (newContentText.length <= contentText.length || newContentText.length <= maxLength) {
      this.fixDeleteOnIE(newContent, editor);
      this.setState({ content: newContent });
      this.props.setContent(newContent);
    } else {
      let selection = editor.exportSelection();
      selection.end -= 1;
      selection.start -= 1;
      editor.setContent(content);
      editor.importSelection(selection, false);
    }
  },
  onEmojiClick(emoji) {
    const { content, selection } = this.state;
    let contentText = this.strip(content);
    let newContent = "";

    if (selection) {
      let front = "";
      let back = "";

      if (selection.start === selection.end) {
        front = contentText.substr(0, selection.start);
        back = contentText.substr(selection.start);
      } else {
        front = contentText.substr(0, selection.start);
        back = contentText.substr(selection.end, contentText.length);
      }

      newContent = front + emoji.native + back;
    } else {
      newContent = contentText + emoji.native;
    }

    this.onChange(newContent, this.refs.textEditor.medium);
  },
  setEditorSelection() {
    this.state.selection = this.refs.textEditor.medium.exportSelection();
  },
  toggleEmojiPicker() {
    const hiddenClass = ' hidden';
    let emojiPicker = ReactDOM.findDOMNode(this.refs.emojiPicker);
    if(emojiPicker.className.includes(hiddenClass)) {
      emojiPicker.className = emojiPicker.className.replace(hiddenClass, '');
    } else {
      emojiPicker.className += hiddenClass;
    }
  },
  componentDidMount() {
    ReactDOM.findDOMNode(this.refs.emojiPicker).className += " hidden";
  },
  render() {
    const { content, options } = this.state;

    return (
      <div className='col-md-12'>
        <div className="emoji-picker-container">
          <Picker emojiSize={27} perLine={9} skin={1} set='twitter' onClick={ this.onEmojiClick } ref="emojiPicker" />
        </div>
        <div>
          <span onClick={ this.toggleEmojiPicker } className="emoji-picker-button"></span>
          <Editor className='input-box' text={ content } onChange={ this.onChange } options={ options } ref="textEditor" onClick={ this.setEditorSelection } onKeyUp={ this.setEditorSelection  }/>
        </div>
      </div>
    )
  }
});

export default Board;
