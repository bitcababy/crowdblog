$ ->
  PostsApp.EditPostView = Backbone.View.extend
    events:
      'keyup #post_body' : 'updatePreview'
      'click .cancel' : 'cancelPost'
      'click .update' : 'updatePost'

    template:
      JST["crowdblog/templates/posts/edit"]

    render: ->
      this.model.fetch()
      this.$el.html(this.template({post: this.model.toJSON(), isNew: this.model.isNew()}))
      @updatePreview()
      this

    cancelPost: (e) ->
      e.preventDefault()
      this.goHome()

    updatePost: (e) ->
      e.preventDefault()
      this.model.save this.extractData(),
        success: =>
          this.goHome()

        error: (e) =>
          errors = $.parseJSON(e.responseText).errors
          console.log errors[0]

          $.each errors, (key, value) =>
            this.$('.control-group.' + key).addClass('error')
            this.$('.' + key + '.help-inline').html(value.join(','))

    updatePreview: ->
      @.$('#post_preview').html markdown.toHTML(@.$('#post_body').val())

    extractData: ->
      {
        'body' : this.$('#post_body').val(),
        'title' : this.$('#post_title').val()
      }

    goHome: ->
      PostsApp.router.navigate '/'
        trigger: true
