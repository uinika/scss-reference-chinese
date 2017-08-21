<div class="copyright" >
  {% set current = date(Date.now(), "YYYY") %}
  &copy; {% if theme.since and theme.since != current %} {{ theme.since }} - {% endif %}
  <span class="author" itemprop="copyrightHolder">{{ config.author }}</span>
  <span class="with-love">
    <i class="fa fa-at"></i>
  </span>
  <span itemprop="copyrightYear">{{ current }}</span>
</div>


