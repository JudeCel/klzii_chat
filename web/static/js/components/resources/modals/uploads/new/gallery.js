import React, {PropTypes} from 'react';
import { connect }        from 'react-redux';
import Actions            from '../../../../../actions/resource';
import UploadTypes        from './../types/index';

const GalleryNew = React.createClass({
  getInitialState() {
    return { selected: [] };
  },
  componentDidMount() {
    this.loadResources();
  },
  isSelected(id) {
    return this.state.selected.includes(id);
  },
  onActivate(e) {
    let id = parseInt(e.currentTarget.getAttribute('data-id'));
    let { selected } = this.state;

    if(this.isSelected(id)) {
      let index = selected.indexOf(id);
      selected.splice(index, 1);
    }
    else {
      selected.push(id);
    }

    this.setState({ selected: selected }, function() {
      this.props.afterChange({ resourceData: { resourceIds: selected } });
    });
  },
  loadResources() {
    const { currentUserJwt, modalName, dispatch } = this.props;
    let data = {};

    if(modalName == 'video') {
      data.type = ['video', 'link'];
      data.scope = ['collage', 'youtube'];
    }
    else {
      data.type = [modalName];
    }

    dispatch(Actions.getGalleryList(currentUserJwt, data));
  },
  render() {
    const { modalName, active, resources } = this.props;

    if(active) {
      if(resources.length == 0) {
        return (
          <div className='col-md-12 gallery-section text-center'>No resources found</div>
        )
      }
      else {
        return (
          <div className='col-md-12 gallery-section'>
            {
              resources.map((resource, index) => {
                return (
                  <div className='col-md-4' key={ resource.id }>
                    <div>
                      <span className='pull-left'>{ resource.name }</span>
                      <span className='pull-right'>
                        <input id={ 'gallery-' + resource.id } type='checkbox' className='with-font' onClick={ this.onActivate } data-id={ resource.id } />
                        <label htmlFor={ 'gallery-' + resource.id }></label>
                      </span>
                    </div>

                    <div>
                      <UploadTypes modalName={ modalName } url={ resource.url } youtube={ resource.scope == 'youtube' } />
                    </div>
                  </div>
                )
              })
            }
          </div>
        )
      }
    }
    else {
      return(false)
    }
  }
});


const mapStateToProps = (state) => {
  return {
    currentUserJwt: state.members.currentUser.jwt,
    resources: state.resources.gallery,
  }
};

export default connect(mapStateToProps)(GalleryNew);
