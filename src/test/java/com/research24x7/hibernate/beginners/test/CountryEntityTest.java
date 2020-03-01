
package com.research24x7.hibernate.beginners.test;


import java.util.ArrayList;
import java.util.List;

import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.hibernate.Transaction;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import org.junit.jupiter.api.*;


import com.research24x7.hibernate.beginners.entity.Country;
import com.research24x7.hibernate.beginners.util.HibernateUtil;


public class CountryEntityTest {


    private static SessionFactory sessionFactory;

    private static final Logger logger = LoggerFactory.getLogger (CountryEntityTest.class);


    public CountryEntityTest() {

        super ();
    }


    @BeforeAll
    public static void setup () {

        sessionFactory = HibernateUtil.getSessionFactory ();
    }

    @AfterAll
    public static void destroy () {

        sessionFactory.close ();
    }


    @Test
    @DisplayName ("Create New Countries")
    public void shouldCreateNewCountries () {


        // Get a session.
        final Session session = sessionFactory.openSession ();
        Transaction tx = null;
        try {

            logger.info("Getting a new transaction...");
            tx = session.beginTransaction ();



            // Set the data to save.
            logger.info("Creating values to insert...");
            List<Country> values = new ArrayList<>();
            for (int i=0; i<5; i++) {
                values.add(new Country (1, "Argentina"));
                values.add(new Country (2, "Brasil"));
                values.add(new Country (3, "Uruguay"));
            }


            // Save the data.
            logger.info(String.format ("Saving data ==> %s", values));
            values.forEach(session::save);
            tx.commit ();
            logger.debug(String.format ("Data %s Saved!!!", values));


            // Checking the values.
            logger.debug("Checking the values saved!!!");
            values.forEach((e) -> {

                Assertions.assertTrue (e.getId () > 0, String.format ("Problems creating new Country %s", e.getName ()));
            });

        } catch (Exception ex) {

            logger.error (ex.getMessage ());
            tx.rollback ();
            Assertions.assertFalse (Boolean.TRUE, "Problems executing the test.");

        } finally { session.close (); }

    }
}