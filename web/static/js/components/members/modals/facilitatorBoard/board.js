import React, {PropTypes} from 'react';
import Editor             from 'react-medium-editor';
import ReactDOM           from 'react-dom';

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
  render() {
    const { content, options } = this.state;

    return (
      <div className='col-md-12'>
        <Editor className='input-box' text={ content } onChange={ this.onChange } options={ options }/>
      </div>
    )
  }
});

export default Board;
