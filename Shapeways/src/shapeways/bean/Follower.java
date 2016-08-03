
package shapeways.bean;

/**
 * Information about the follower
 * 
 * @author Udita
 */
public class Follower {
    
    // user id
    private int userId;
  
    /**
     * integer id to uniquely identify the follower
     * @param userId unique id
     */
    public Follower(int userId) {
        this.userId = userId;
    }

    /**
     * returns the unique user id
     * @return integer id
     */
    public int getUserId() {
        return userId;
    }

    @Override
    public int hashCode() {
        return super.hashCode();
    }

    @Override
    public boolean equals(Object obj) {
        if (obj == null) {
            return false;
        }
        if (getClass() != obj.getClass()) {
            return false;
        }
        final Follower other = (Follower) obj;
        
        // two users are equal if their user ids are equal
        return this.userId == other.userId;
    }

    @Override
    public String toString() {
        return userId + "";
    }

}
