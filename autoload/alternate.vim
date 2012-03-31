function alternate#Alternate()
  execute "edit " . alternate#FindAlternate()
endfunction

function alternate#FindAlternate()
  let directory_name = expand("%:h:t")
  let file_name      = expand("%:t:r:r")
  let file_extension = expand("%:e:e")
  if s:IsTest(file_name)
    return s:FindImplementation(directory_name, file_name, file_extension)
  else
    return s:FindTest(directory_name, file_name, file_extension)
  endif
endfunction

function s:IsTest(file_name)
  return match(a:file_name, '_spec$') != -1
endfunction

function s:FindImplementation(directory_name, file_name, file_extension)
  return s:FindClosestMatch(a:directory_name, "**/" . substitute(a:file_name, '_spec', '', '') . "." . a:file_extension)
endfunction

function s:FindTest(directory_name, file_name, file_extension)
  return s:FindClosestMatch(a:directory_name, "spec/**/" . a:file_name . "_spec" . "." . a:file_extension)
endfunction

function s:FindClosestMatch(directory_name, search_pattern)
  let matches = split(glob(a:search_pattern), "\n")
  if len(matches) > 1
    for result in matches
      if fnamemodify(result, ':h:t') == a:directory_name
        return result
      endif
    endfor
  endif
  return get(matches, 0)
endfunction

