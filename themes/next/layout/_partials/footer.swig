<div class="copyright" >
  {% set current = date(Date.now(), "YYYY") %}
  &copy; {% if theme.since and theme.since != current %} {{ theme.since }} - {% endif %}
  <span itemprop="copyrightYear">{{ current }}</span>
  <b class="author" itemprop="copyrightHolder">{{ config.author }}</b>
  <span class="with-love">
    , All Rights Reserved
  </span>
</div>


