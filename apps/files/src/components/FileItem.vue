<template>
  <oc-file
    :name="fileName"
    :extension="item.extension"
    :icon="previewIcon"
    :iconUrl="previewUrl"
    :filename="item.name"
    />
</template>
<script>
import queryString from 'query-string'
import Mixins from '../mixins'

export default {
  name: 'FileItem',
  mixins: [
    Mixins
  ],
  props: {
    item: {
      type: Object
    },
    davUrl: {
      type: String
    },
    showPath: {
      type: Boolean,
      default: false
    }
  },
  data: function () {
    return {
      previewUrl: this.item.previewUrl
    }
  },
  computed: {
    fileName () {
      if (this.showPath) {
        const pathSplit = this.item.path.substr(1).split('/')
        if (pathSplit.length === 2) return `${pathSplit[pathSplit.length - 2]}/${this.item.basename}`
        if (pathSplit.length > 2) return `…/${pathSplit[pathSplit.length - 2]}/${this.item.basename}`
      }
      return this.item.basename
    },
    previewIcon () {
      return this.fileTypeIcon(this.item)
    }
  },
  mounted () {
    this.loadPreview()
  },
  methods: {
    loadPreview () {
      if (this.item.previewUrl) {
        this.previewUrl = this.item.previewUrl
        return
      }

      // TODO: check if previews are globally enabled (requires capability entry)
      // don't load previews for pending or rejected shares (status)
      if (!this.davUrl || this.item.type === 'folder' || (typeof this.item.status !== 'undefined' && this.item.status !== 0)) {
        return
      }
      const query = queryString.stringify({
        x: this.thumbDimensions,
        y: this.thumbDimensions,
        c: this.item.etag,
        scalingup: 0,
        preview: 1,
        a: 1
      })

      let itemPath = this.item.path
      if (itemPath.charAt(0) === '/') {
        itemPath = itemPath.substr(1)
      }

      const previewUrl = this.davUrl + '/' + this.encodePath(itemPath) + '?' + query

      this.mediaSource(previewUrl, 'url', this.requestHeaders).then(dataUrl => {
        // cache inside item
        this.previewUrl = this.item.previewUrl = dataUrl
      })
    }
  }
}
</script>
