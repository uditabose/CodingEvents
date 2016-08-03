

package shapeways.algo;

import java.io.BufferedWriter;
import java.io.FileWriter;
import java.io.IOException;
import java.util.Collection;
import java.util.HashSet;
import java.util.Set;
import shapeways.bean.Artist;
import shapeways.bean.Follower;

/**
 * The implementation of pair collector algorithm
 * 
 * @author Udita
 */
public class PairCollector {
    
    /**
     * collects the pairs of artists who have at-least 50 followers in common
     * 
     * Note : 1. Finds if an artist has at-least 50 followers
     *        2. If so, then tries to find intersection of followers of the artist
     *              with the follower of other artist who also has at-least 50 followers
     *        3. If the size if the intersection is at-least 50 report that pair.
     * 
     * This algorithm can be improved with use of Bloom-filter, which will help 
     * to determine if a follower is "most probably" in the intersection of both 
     * the artist's follower list. But bloom filter has not been implemented, as 
     * that would require an efficient hash code implementation. Can use some 
     * library like Google Guava to use the Bloom Filter, but was not sure if allowed
     * to use any external library. 
     * 
     * @param outputPath file path to write the artist pairs
     * @param dataSink the data sink which holds all the artist and follower data
     * @throws IOException if the file can not be written
     */
    public void collectPair(String outputPath, DataSink dataSink) throws IOException {
        
        // the output writer
        BufferedWriter pairWriter = new BufferedWriter(new FileWriter(outputPath, false));
        
        // all artists
        Collection<Artist> allArtists = dataSink.getAllArtists();
        
        // the artists for which pairs a
        Set<String> testedArtist = new HashSet<>();
        for (Artist artist : allArtists) {

            // move to next artist if artist does not have at-least 50
            // followers or already we have computed the result for the pair
            // this step optimizes the calculation by avoiding the artists
            // who does not have 50 followers, hence can not appear in 50 pairs
            if (artist.getFollowers().size() < 50 
                    || testedArtist.contains(artist.getArtistName())) {
                
                // add the artist the tested list
                testedArtist.add(artist.getArtistName());
                continue;
            }
            
            // add the artist the tested list
            testedArtist.add(artist.getArtistName());
            
            // first loop over all the artists
            for (Artist nextArtist : allArtists) {
                
                // move to next artist if artist does not have at-least 50
                // followers or already we have computed the result for the pair
                if (nextArtist.getFollowers().size() < 50 
                    || testedArtist.contains(nextArtist.getArtistName())) {
                    continue;
                }
                
                // calculate the intersection of the followers of the users
                Set<Follower> combinedUsers = new HashSet(artist.getFollowers());
                combinedUsers.retainAll(nextArtist.getFollowers());
                
                // consider the pair of artist only iff the set size is more than 
                // or equal to 50
                if (combinedUsers.size() >= 50) {
                    
                    // write the pair
                    pairWriter.write(String.format("(%s, %s)", artist.getArtistName(), 
                            nextArtist.getArtistName()));
                    pairWriter.newLine();
                }
            }
        }
        
        // flush and close the output writer
        pairWriter.flush();
        pairWriter.close();
        
    }

}
