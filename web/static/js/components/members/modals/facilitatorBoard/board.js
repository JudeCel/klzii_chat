import React, {PropTypes} from 'react';
import Editor             from 'react-medium-editor';
import ReactDOM           from 'react-dom';

const Board = React.createClass({
  getInitialState() {
    this.maxInputLength = 200;
    return {
      content: this.props.boardContent,
      options: {
        toolbar: { buttons: ['bold', 'italic', 'anchor'] }
      }
    };
  },
  onKeyPress(e) {
    let element = ReactDOM.findDOMNode(this).querySelector('.input-box');
    if(element.textContent.length > this.maxInputLength) {
      e.preventDefault();
      e.stopPropagation();
    }
  },
  onChange(content, data) {
    if(data.origElements.textContent.length < this.maxInputLength) {
      this.setState({ content: content });
      this.props.setContent(content);
    }
  },
  render() {
    const { content, options } = this.state;

    return (
      <div className='col-md-12'>
        <Editor className='input-box' text={ content } onChange={ this.onChange } options={ options } onKeyPress={ this.onKeyPress } />
      </div>
    )
  }
});

export default Board;
