

package shapeways.others;

/**
 *
 * @author Udita
 */
public class RepeatedCharacters {
    
    public static void main(String[] args) {
        if (args == null || args.length == 0) {
            args = new String[]{"sssssTTTTTToNNps"};
        }

        String modString = replaceRepeatedCharacters(args[0]);
        System.out.println(modString);
    }

    public static String replaceRepeatedCharacters(String testString) {
        char currentChar = testString.charAt(0);
        int charCnt = 0;
        StringBuilder retBuilder = new StringBuilder();
        
        for (char cChar : testString.toCharArray()) {
            if ( cChar == currentChar ) {
                charCnt++;
            } else {
                retBuilder.append(currentChar);
                if (charCnt > 1) {
                    retBuilder.append(charCnt);
                }    
                currentChar = cChar;
                charCnt = 1;
            }
        }
        
        retBuilder.append(currentChar);
        if (charCnt > 1) {
            retBuilder.append(charCnt);
        }
        
        return retBuilder.toString();
    }

}
