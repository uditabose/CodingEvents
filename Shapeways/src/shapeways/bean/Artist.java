

package shapeways.bean;


import java.util.HashSet;
import java.util.Objects;
import java.util.Set;

/**
 * Information of an artist
 * 
 * @author Udita
 */
public class Artist {
    
    // artist name
    private String artistName;
    
    // set of unique followers for this artist
    private final Set<Follower> followers;

    /**
     * Constructor, initializes the empty set of followers
     */
    public Artist() {
        this.followers = new HashSet<>();
    }

    /**
     * Constructor, initializes the empty set of followers,
     * and sets the user name
     * 
     * @param artistName name of the artist
     */
    public Artist(String artistName) {
        this();
        this.artistName = artistName;
    }

    /**
     * returns the artist name
     * @return artist name
     */
    public String getArtistName() {
        return artistName;
    }

    /**
     * returns all the followers
     * @return set of followers
     */
    public Set<Follower> getFollowers() {
        return followers;
    }

    /**
     * adds a new follower
     * @param aFollower a new follower
     */
    public void addFollower(Follower aFollower) {
        
        // to prevent concurrent modification errors
        synchronized(this.followers) {
            this.followers.add(aFollower);
        }
    }

    @Override
    public boolean equals(Object obj) {
        if (obj == null) {
            return false;
        }
        if (getClass() != obj.getClass()) {
            return false;
        }
        final Artist other = (Artist) obj;
        
        // two users are equal if their lowercase names are
        return Objects.equals(this.artistName.toLowerCase(), other.artistName.toLowerCase());
    }

    @Override
    public int hashCode() {
        return super.hashCode();
    }

    @Override
    public String toString() {
        return "Artist{" + "artistName=" + artistName + ", followers=" + followers + '}';
    }
    
    
    
    
}
