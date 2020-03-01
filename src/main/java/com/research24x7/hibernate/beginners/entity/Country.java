
package com.research24x7.hibernate.beginners.entity;


import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import javax.persistence.*;
import java.util.HashSet;
import java.util.Set;


@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
@Entity (name =  "Country")
@Table (name = "country")
public class Country {

	@Id
	@GeneratedValue (strategy=GenerationType.IDENTITY)
	@Column (name="cou_id", nullable=false, unique=true)
	private int id;
	
	@Column(name="cou_name", length=28, nullable=false)
	private String name;

}