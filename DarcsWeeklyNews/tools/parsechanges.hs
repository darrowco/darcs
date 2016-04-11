import Data.Char ( toLower, isDigit, isSpace )
import Data.List ( isPrefixOf, groupBy, sortBy, intersperse )
import Data.Maybe ( fromMaybe )
import Data.Function ( on )
import Text.XML.Light

main :: IO ()
main = interact $ maybe "parse error :-(" go . parseXMLDoc

go :: Element -> String
go e =
  concat . intersperse "\n" $
   [ section iheader ibody
   , section pheader pbody ]
 where
  section x b = unlines $ [ "# " ++ x, ""] ++ b
  pheader = "Patches applied (" ++ show (length patches) ++ ")"
  pbody   = map showPatches . clump $ patches
  iheader = "Issues resolved (" ++ show (length issues) ++ ")"
  ibody   = map showIssue issues
  patches = map patchinfo . init_ . findChildren (unqual "patch") $ e
  issues  = sortBy (compare `on` fst) . map getIssue . filter resolved $ patches
  readInt = read :: (String -> Int)

init_ :: [a] -> [a]
init_ [] = []
init_ xs = init xs

data Patch = P { author   :: String
               , datetime :: String -- ^ ISO 8601 no seps
               , name     :: String
               }
 deriving Show

clump :: [Patch] -> [[Patch]]
clump = groupBy ((==) `on` author)

type Issue = (Int, Patch)

getIssue :: Patch -> Issue
getIssue p = (i,p)
 where
  i = read . takeWhile isDigit . dropWhile (not . isDigit) $ name p

showIssue :: Issue -> String
showIssue (i,p) =
 unlines [ "issue" ++ (show i) ++ " " ++ authorLite
         , "  ~ -   " ++ (unwords . drop 2 . words $ name p)
         , "    -   <http://bugs.darcs.net/issue" ++ show i ++ ">" ]
 where
  authorLite = dropEmail . author $ p

dropEmail :: String -> String
dropEmail = reverse . dropWhile isSpace . reverse . takeWhile (/= '<')

resolved :: Patch -> Bool
resolved p = "resolve issue" `isPrefixOf` (map toLower . name $ p)

showPatches :: [Patch] -> String
showPatches [] = ""
showPatches ps@(p:_) =
 unlines $
   (niceDate ++ " " ++ niceAuthor) : insertTilde (map showName ps)
 where
  (yyyy,d2) = splitAt 4 $ datetime p
  (mm,d3) = splitAt 2 d2
  (dd,_ ) = splitAt 2 d3
  showName x = "    -   " ++ name x
  niceDate = yyyy ++ "-" ++ mm ++ "-" ++ dd
  niceAuthor = dropEmail . author $ p
  insertTilde (p:ps) = ("  ~" ++ (drop 3  p)):ps

patchinfo :: Element -> Patch
patchinfo p = P (myfind "author") (myfind "date") name
 where
  name = maybe "" strContent $ findChild (unqual "name") p
  myfind x = fromMaybe ("no " ++ x ++ "?!")
           $ findAttr (unqual x) p
