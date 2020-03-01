
package com.research24x7.hibernate.beginners.test;


import java.util.List;

import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.hibernate.Transaction;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import org.junit.jupiter.api.*;

import com.research24x7.hibernate.beginners.util.HibernateUtil;
import com.research24x7.hibernate.beginners.entity.*;


public class RemoveAllEntitiesTest {


    private static SessionFactory sessionFactory;

    private static final Logger logger = LoggerFactory.getLogger (RemoveAllEntitiesTest.class);


    public RemoveAllEntitiesTest() {

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
    @DisplayName ("Deleting All Data")
    public void shouldRemoveAllData () {


        // Get a session.
        final Session session = sessionFactory.openSession ();
        Transaction tx = null;

        try {

            logger.info("Getting a transaction...");
            tx = session.beginTransaction ();


            // Get the data to remove.


            logger.debug("Finding countries");
            List<Country> countries = session.createCriteria(Country.class).list();



            // Check the countries.
            Assertions.assertFalse(countries.isEmpty(), "There are not countries!!!");


            // Delete data.


            logger.debug("Deleting countries");
            countries.forEach(session::delete);
            tx.commit ();


            // Check the data removed.
            /// Find the data again.

            logger.debug("Finding countries");
            countries = session.createCriteria(Country.class).list();



            // Check the countries.
            Assertions.assertTrue(countries.isEmpty(), "There are countries!!!");

        } catch (Exception ex) {

            logger.error (ex.getMessage ());
            tx.rollback ();
            Assertions.assertFalse (Boolean.TRUE, "Problems executing the test.");

        } finally { session.close (); }
    }
}