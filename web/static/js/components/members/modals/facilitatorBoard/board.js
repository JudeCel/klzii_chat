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
  onChange(content) {
    this.setState({ content });
    this.props.setContent(content);
  },
  render() {
    const { content, options } = this.state;

    return (
      <div className='col-md-12'>
        <Editor className='input-box' text={ content } onChange={ this.onChange } options={ options } />
      </div>
    )
  }
});

export default Board;
