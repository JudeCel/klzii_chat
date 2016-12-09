import React, {PropTypes} from 'react';
import Editor             from 'react-medium-editor';
import ReactDOM           from 'react-dom';
import { Picker }         from 'emoji-mart';

const Board = React.createClass({
  getInitialState() {
    return {
      content: this.props.boardContent,
      options: {
        toolbar: { buttons: ['bold', 'italic', 'anchor'] }
      },
      showEmojiPicker: false,
      emojiPickerOptions: {
        title: "Pick your emoji",
        emojiSize: 28,
        perLine: 13,
        skin: 1,
        set: 'twitter'
      }
    };
  },
  strip(html) {
    var tmp = document.createElement("div");
    tmp.innerHTML = html;
    return tmp.textContent || tmp.innerText || "";
  },
  onChange(newContent, editor) {
    const { content } = this.state;
    const maxLength = 150;
    let contentText = this.strip(content);
    let newContentText = this.strip(newContent);

    if (newContentText.length <= contentText.length || newContentText.length <= maxLength) {
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
    this.setState({ showEmojiPicker: !this.state.showEmojiPicker });
  },
  emojiPickerDisplayStyle() {
    return this.state.showEmojiPicker ? null : { display: 'none' };
  },
  render() {
    const { content, options, emojiPickerOptions } = this.state;

    return (
      <div className='col-md-12'>
        <div className="emoji-picker-container">
            <Picker title={emojiPickerOptions.title} emojiSize={emojiPickerOptions.emojiSize} perLine={emojiPickerOptions.perLine} skin={emojiPickerOptions.skin} set={emojiPickerOptions.set} onClick={ this.onEmojiClick } ref="emojiPicker" style={ this.emojiPickerDisplayStyle() } />
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
