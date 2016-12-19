import React, {PropTypes} from 'react';
import { connect }        from 'react-redux';
import Pagination         from "react-js-pagination";
import Actions            from '../../../../../actions/session_resource';
import UploadTypes        from './../types/index';
import mixins             from '../../../../../mixins';

const GalleryNew = React.createClass({
  mixins: [mixins.paginationHelper],
  getInitialState() {
    return { selected: [], page: 1 };
  },
  componentDidUpdate() {
    setTimeout(() => { this.initPaginatorButton('galleryPaginator') }, 0);
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
    let { page } = this.state;
    let data = {};

    if(modalName == 'video') {
      data.type = ['video', 'link'];
      data.scope = ['collage', 'videoService'];
    }
    else if(modalName == 'file') {
      data.type = [modalName];
      data.scope = ['pdf'];
    }
    else {
      data.type = [modalName];
    }
    data.page = page;

    dispatch(Actions.getGallery(currentUserJwt, data));
  },
  pageChange(pageNumber) {
    if (pageNumber != this.state.page) {
      this.setState({ page: pageNumber }, function() {
        this.loadResources();
      });
    }
  },
  render() {
    const { modalName, active, gallery, pages } = this.props;

    if(active) {
      if(gallery.length == 0) {
        return (
          <div className='col-md-12 gallery-section text-center'>No resources found</div>
        )
      }
      else {
        return (
          <div className='col-md-12 gallery-section'>
            {
              gallery.map((resource, index) => {
                return (
                  <div className='col-md-4' key={ resource.id }>
                    <div className='row top-row'>
                      <div className='resource-title pull-left'>{ resource.name }</div>
                      <div className='pull-right'>
                        <input id={ 'gallery-' + resource.id } type='checkbox' className='with-font' onClick={ this.onActivate } data-id={ resource.id } />
                        <label htmlFor={ 'gallery-' + resource.id }></label>
                      </div>
                    </div>

                    <div className='row'>
                      <UploadTypes modalName={ modalName } url={ resource.url } videoService={ resource.scope == 'videoService' } source={ resource.source } />
                    </div>
                  </div>
                )
              })
            }
            <div className="paginator" id="galleryPaginator">
              <Pagination
                activePage={this.state.page}
                itemsCountPerPage={1}
                totalItemsCount={pages}
                pageRangeDisplayed={5}
                onChange={this.pageChange}
              />
            </div>
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
    gallery: state.resources.gallery,
    pages: state.resources.pages,
  }
};

export default connect(mapStateToProps)(GalleryNew);
