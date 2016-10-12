import React, {PropTypes} from 'react';
import { connect }        from 'react-redux';
import Pagination         from "react-js-pagination";
import Actions            from '../../../../../actions/session_resource';
import UploadTypes        from './../types/index';

const GalleryNew = React.createClass({
  getInitialState() {
    return { selected: [], page: 1 };
  },
  componentDidMount() {
    this.loadResources();
  },
  initPaginatorButton() {
    let { page } = this.state;
    const { pages } = this.props;

    var galleryPaginator = document.getElementById('galleryPaginator');
    if (galleryPaginator) {
      var el = galleryPaginator.getElementsByClassName('pagination')[0];
      if (el) {
        var oldElements = galleryPaginator.getElementsByClassName('paginatorFakeButton');
        for(var i=oldElements.length-1; i>=0; i--) {
          el.removeChild(oldElements[i]);
        }
        if (el.innerHTML.indexOf('⟨') < 0) {
          let button = this.createPaginatorButtonElement('⟨', page > 1, 1);
          el.insertBefore(button, el.firstChild);
        }
        if (el.innerHTML.indexOf('«') < 0) {
          let button = this.createPaginatorButtonElement('«', page > 1, 1);
          el.insertBefore(button, el.firstChild);
        }
        if (el.innerHTML.indexOf('⟩') < 0) {
          let button = this.createPaginatorButtonElement('⟩', page < pages, pages);
          el.appendChild(button);
        }
        if (el.innerHTML.indexOf('»') < 0) {
          let button = this.createPaginatorButtonElement('»', page < pages, pages);
          el.appendChild(button);
        }
      }
    }
  },
  createPaginatorButtonElement(text, active, page) {
    let liEl = document.createElement("li");
    let aEl = document.createElement("a");
    aEl.innerHTML = text;
    if (active) {
      aEl.href = "#";
    }
    liEl.appendChild(aEl);
    liEl.className = "paginatorFakeButton";
    if (active) {
      liEl.onclick = () => {
        this.pageChange(page);
      };
    } else {
      liEl.className += " unactive"
    }
    return liEl;
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
      data.scope = ['collage', 'youtube'];
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
    this.initPaginatorButton();
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
                      <UploadTypes modalName={ modalName } url={ resource.url } youtube={ resource.scope == 'youtube' } />
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
