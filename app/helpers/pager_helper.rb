# -*- coding: utf-8 -*-
module PagerHelper
  MAX_RECORDS_PER_PAGE = 25

  def pager(entityClass)
    offset = @page * MAX_RECORDS_PER_PAGE
    entityClass.offset(offset).limit(MAX_RECORDS_PER_PAGE)
  end

  def setupPager(entity, params)
    @page = params[:page] ||= 0
    @page = @page.to_i
    @page = 0 unless @page >= 0
    calcPageCount(entity)
  end

  def calcPageCount(entity)
    @pageCount = (entity.count / MAX_RECORDS_PER_PAGE).ceil
  end

  def pagerViewStart(urlmeth)
    if @pageCount > 1
      return link_to 'Anfang', urlmeth.call(:page => 0), :class => 'main'
    end
    ''
  end

  def pagerViewEnd(urlmeth)
    if @pageCount > 1
      return link_to 'Ende', urlmeth.call(:page => @pageCount), :class => 'main'
    end
    ''
  end

  def pagerViewNext(urlmeth)
    nextPage = @page+1
    if nextPage < @pageCount
      return link_to 'Vor', urlmeth.call(:page => nextPage), :class => 'main'
    end
    ''
  end

  def pagerViewPrev(urlmeth)
    prevPage = @page-1
    if prevPage > 0
      return link_to 'Zurück', urlmeth.call(:page => prevPage), :class => 'main'
    end
    ''
  end
end
