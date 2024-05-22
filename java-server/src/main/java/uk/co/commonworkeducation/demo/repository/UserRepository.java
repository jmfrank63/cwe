package uk.co.commonworkeducation.demo.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import uk.co.commonworkeducation.demo.domain.User;

public interface UserRepository extends JpaRepository<User, Long> {}
